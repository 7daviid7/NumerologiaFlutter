import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../services/history_service.dart';
import 'feedback_detail_page.dart';

class FeedbackListPage extends StatefulWidget {
  FeedbackListPage({Key? key}) : super(key: key);

  @override
  _FeedbackListPageState createState() => _FeedbackListPageState();
}

class _FeedbackListPageState extends State<FeedbackListPage> {
  final HistoryService _historyService = HistoryService();

  // State variables for Stream Management
  List<DocumentSnapshot> _items = [];
  StreamSubscription<QuerySnapshot>? _streamSubscription;

  // Pagination State
  int _currentLimit = 20;
  final int _increment = 20;

  // Search State
  bool _isSearching = false;
  String? _currentSearchName;
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;
  bool _hasMore = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _setupStream();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    setState(() {
      _isSearching = false;
      _currentSearchName = null;
      _searchController.clear();
      _currentLimit = 20;
      _hasMore = true;
      _isLoading = true;
    });
    _setupStream();
  }

  void _setupStream() {
    _streamSubscription?.cancel();

    Stream<QuerySnapshot> stream;

    if (_isSearching && _currentSearchName != null) {
      // MODE A: Filtered Search (No Pagination limit needed usually for one person,
      // but if needed we could implement it. For now, we fetch all for that person).
      stream = _historyService.getHistoryByName(_currentSearchName!);
    } else {
      // MODE B: Infinite Scroll (Normal)
      stream = _historyService.getHistoryStream(limit: _currentLimit);
    }

    _streamSubscription = stream.listen(
      (snapshot) {
        if (!mounted) return;
        setState(() {
          _items = snapshot.docs;
          _isLoading = false;

          if (_isSearching) {
            _hasMore = false; // No infinite scroll in search mode
          } else {
            // Infinite scroll logic
            if (snapshot.docs.length < _currentLimit) {
              _hasMore = false;
            } else {
              _hasMore = true;
            }
          }
        });
      },
      onError: (error) {
        if (!mounted) return;
        setState(() {
          _errorMessage = error.toString();
          _isLoading = false;
        });
      },
    );
  }

  bool _onScroll(ScrollNotification notification) {
    // Only paginate if NOT searching
    if (_isSearching) return false;

    if (notification is ScrollEndNotification &&
        notification.metrics.extentAfter < 500) {
      if (_hasMore && !_isLoading) {
        if (mounted) {
          if (_items.length >= _currentLimit) {
            setState(() {
              _currentLimit += _increment;
            });
            _setupStream();
          }
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? _buildSearchField()
            : const Text('Historial i Feedback'),
        centerTitle: true,
        actions: [
          if (!_isSearching)
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },
            ),
          if (_isSearching)
            IconButton(
              icon: Icon(Icons.close),
              onPressed: _clearSearch,
            )
        ],
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: _onScroll,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildSearchField() {
    return TypeAheadField<String>(
      builder: (context, controller, focusNode) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          autofocus: true,
          style: TextStyle(
              color: Colors.black), // Ensure text is visible depending on theme
          decoration: InputDecoration(
            hintText: 'Cerca per nom...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey),
          ),
        );
      },
      suggestionsCallback: (pattern) async {
        return await _historyService.searchNames(pattern);
      },
      itemBuilder: (context, String suggestion) {
        return ListTile(
          leading: Icon(Icons.person),
          title: Text(suggestion),
        );
      },
      onSelected: (String suggestion) {
        setState(() {
          _currentSearchName = suggestion;
          _searchController.text = suggestion;
          _isLoading = true;
        });
        _setupStream();
      },
      emptyBuilder: (context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('No s\'han trobat noms.',
            style: TextStyle(color: Colors.grey)),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(child: Text('Error: $_errorMessage'));
    }

    if (_items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history_edu, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              _isSearching
                  ? 'No hi ha informes per "$_currentSearchName"'
                  : 'No hi ha interpretacions guardades.',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(16),
      separatorBuilder: (context, index) => SizedBox(height: 12),
      itemCount: _items.length + 1,
      itemBuilder: (context, index) {
        if (index == _items.length) {
          if (_isSearching) return SizedBox.shrink(); // No footer in search

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Center(
              child: Opacity(
                opacity: 0.6,
                child: _hasMore
                    ? CircularProgressIndicator(strokeWidth: 2)
                    : Text(
                        'No hi ha més resultats',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
              ),
            ),
          );
        }

        final docSnapshot = _items[index];
        final data = docSnapshot.data() as Map<String, dynamic>;
        final docId = docSnapshot.id;

        return KeyedSubtree(
          key: ValueKey(docId),
          child: _buildItem(context, data, docId),
        );
      },
    );
  }

  Widget _buildItem(
      BuildContext context, Map<String, dynamic> data, String docId) {
    final name = data['fullName'] ?? 'Desconegut';
    final birthDate = data['birthDate'] ?? 'Sense data';
    final feedback = data['feedback'] as String?;

    String dateStr = '';
    if (data['timestamp'] != null && data['timestamp'] is Timestamp) {
      final date = (data['timestamp'] as Timestamp).toDate();
      dateStr = DateFormat('dd/MM HH:mm').format(date);
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FeedbackDetailPage(
                data: data,
                docId: docId,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Data naixement: $birthDate',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      'Creat: $dateStr',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              if (feedback != null)
                Icon(
                  feedback == 'positive' ? Icons.thumb_up : Icons.thumb_down,
                  color: feedback == 'positive' ? Colors.green : Colors.red,
                ),
              SizedBox(width: 8),
              Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

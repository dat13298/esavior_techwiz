import 'package:flutter/material.dart';
import '../../models/feedbacks.dart';
import '../../services/account_service.dart';
import 'customAppBar.dart';

class FeedBackTab extends StatefulWidget {
  const FeedBackTab({Key? key}) : super(key: key);

  @override
  _FeedBackTabState createState() => _FeedBackTabState();
}

class _FeedBackTabState extends State<FeedBackTab> {
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';
  late Stream<List<Feedbacks>> _feedbackStream;

  @override
  void initState() {
    super.initState();
    // Gọi method từ AccountService
    _feedbackStream = AccountService().getAllFeedBack();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Feedback Manager',
        subtitle: 'All feedbacks',
        showBackButton: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchTerm = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Search by key word',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Feedbacks>>(
              stream: _feedbackStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No feedbacks found'));
                }

                List<Feedbacks> feedbackList = snapshot.data!;

                // Nếu có từ tìm kiếm, lọc kết quả
                if (_searchTerm.isNotEmpty) {
                  feedbackList = feedbackList
                      .where((feedback) => feedback.content.contains(_searchTerm))
                      .toList();
                }

                return ListView.builder(
                  itemCount: feedbackList.length,
                  itemBuilder: (context, index) {
                    final feedback = feedbackList[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      child: ListTile(
                        title: Text('ID: ${feedback.id}'),
                        subtitle: Text('Message: ${feedback.content}'),
                        trailing: Text('Date: ${feedback.formattedDateTime}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

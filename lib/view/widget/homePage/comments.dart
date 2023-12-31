import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/homepage_controller.dart';


class Comments extends StatelessWidget {
  Comments({super.key, required this.postId}){
    thePostId=postId;
    



  }
  final HomePageControllerImp controller = Get.put(HomePageControllerImp());
  final TextEditingController commentController = TextEditingController();
   final int postId;
   late int thePostId;

  @override
  Widget build(BuildContext context) {
    return Container(
            height: MediaQuery.of(context).size.height * 0.75, // Adjust the height as needed
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Obx(
        () => 
         Column(
          
            children: [
          /*    MaterialButton(onPressed: (){
                Get.delete<HomePageControllerImp>();
                Get.back();
              },child: Text("back"),),*/
              Flexible(
                
                child: ListView.builder(
                  itemCount: controller.comments.length,
                  itemBuilder: (context, index) {
                    if(thePostId==controller.comments[index].postId)
                    {
                    final comment = controller.comments[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: ListTile(
                        onTap: (){
                          controller.gotoprofileFromcomment(comment.email);

                        },
                        contentPadding: const EdgeInsets.all(8.0),
                        leading: CircleAvatar(
                          backgroundImage: comment.userImage,
                        ),
                        title: Text(comment.username),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(comment.comment),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                IconButton(
                                  icon: Obx(() => Icon(
                                    Icons.thumb_up,
                                    color: comment.likes.value > 0 ? Colors.blue : null,
                                  )),
                                  onPressed: () {
                                    controller.toggleLikecomment(index);
                                  },
                                ),

                                Obx(() => Text('${comment.likes} Likes')),
                                const SizedBox(width: 16),
                                Text(
                                  'Posted ${timeAgoSinceDate(comment.time)}',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }else{
                    return Container();
                  }
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: commentController,
                          decoration: const InputDecoration(
                            hintText: 'Write a comment...',
                            hintStyle: TextStyle(
                              fontSize: 14,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 30,
                            ),
                          
                            
                          ),
                          
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          const username = 'Current User';
                          final newComment = commentController.text;
                          const  Email='awsobaida07@gmail.com';
                          
                          controller.addComment(username, newComment,Email,thePostId);
                          print(username );
                          print(thePostId);
                          commentController.clear();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      
    );
  }

  String timeAgoSinceDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}
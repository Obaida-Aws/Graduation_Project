import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growify/controller/home/homepage_controller.dart';
import 'package:growify/view/widget/homePage/commentsMainpage.dart';


class Post extends StatelessWidget {
  const Post({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GetBuilder<HomePageControllerImp>(
        init: HomePageControllerImp(),
        builder: (controller) {
          return ListView.builder(
            itemCount: controller.posts.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final post = controller.posts[index];

              return Container(
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      // controller.goToProfilePage();
                                      // For testing purposes, toggle like on image tap
                                      // controller.toggleLike(index);
                                      controller.goToProfileColleaguesPage(
                                          post['email']);
                                    },
                                    child: CircleAvatar(
                                      backgroundImage:
                                          AssetImage(post['image']),
                                      radius: 30,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            post['name'],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        post['time'],
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              PopupMenuButton<String>(
                                  icon: const Icon(Icons.more_vert),
                                  onSelected: (String option) {
                                    controller.onMoreOptionSelected(option);
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return controller.moreOptions
                                        .map((String option) {
                                      return PopupMenuItem<String>(
                                        value: option,
                                        child: Text(option),
                                      );
                                    }).toList();
                                  })

                              /*  IconButton(
                                onPressed: () {
                                  // Show more choice

                                },
                                icon: const Icon(Icons.more_vert),
                              )*/
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            post['content'],
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 10),
                          Image.asset(post['image']),
                          const SizedBox(height: 5),
                          Container(
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    //go to like page
                                    int postId =post['id'];
                                    //controller.goToLikePage(postId);
                                  },
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.thumb_up,
                                        color: Colors.blue,
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(left: 10, right: 5),
                                        child: Text(
                                          '${controller.getLikes(index)}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        'Likes',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 100,
                                ),
                                InkWell(
                                  onTap: () {

                                    int postId =post['id'];
                                    print(postId);
                                    Get.to(CommentsMainPage(id: postId, ),
                                    
                                    );

                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(left: 10, right: 5),
                                        child: Text(
                                          '${controller.getComments(index)}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        'Comments',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            color: Color.fromARGB(255, 194, 193, 193),
                            thickness: 1.0,
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 20),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    controller.toggleLike(index);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 35),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.thumb_up,
                                          color: controller.isLiked(index)
                                              ? Colors.blue
                                              : Colors.grey,
                                        ),
                                        const Text("Like")
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 135),
                                InkWell(
                                  onTap: () {
                                    //go to comment page
                                    int postId =post['id'];
                                    Get.to(CommentsMainPage(id: postId,));
                                  },
                                  child: const Column(
                                    children: [
                                      Icon(
                                        Icons.comment,
                                        color: Colors.grey,
                                      ),
                                      Text("Comment")
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

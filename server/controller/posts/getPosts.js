
const User = require("../../models/user");
const Page = require("../../models/pages");
const path = require('path');
const fs = require('fs');
const jwt = require('jsonwebtoken');
require('dotenv').config();
const post = require('../../models/post');
const comment = require('../../models/comment');
const like = require('../../models/like');
async function findIfUserInConnections(userUsername, findProfileUsername) {
    const userConnections = await Connections.findAll({
        where: {
            [Op.or]: [
                { senderUsername: userUsername },
                { receiverUsername: userUsername },
            ],
        },
        include: [{
            model: User,
            as: 'senderUsername_FK',
            attributes: ['username'],
        }, {
            model: User,
            as: 'receiverUsername_FK',
            attributes: ['username'],
        }],
    });
    const userInConnections = userConnections.filter(connection => {
        // Check if the username is in senders or receivers
        return connection.senderUsername_FK.username === findProfileUsername || connection.receiverUsername_FK.username === findProfileUsername;
    });
    return userInConnections;
}



exports.getPostComments = async (req, res, next) => {
    try {
        const { postId } = req.body;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        const existingUsername = await User.findOne({
            where: {
                username: userUsername
            },
        });
        if (existingUsername) {
            const userPostComments = await post.findOne({
                where: { id: postId },
                include: [
                    {
                        model: comment,
                        order: [['Date', 'DESC']],
                    },

                ],
            });
            if (!userPostComments) {
                return res.status(404).json({ error: 'Post not found' });
            }

            if (userPostComments.username == userUsername) {

                const comments = await Promise.all(userPostComments.comments.map(async (comment) => {
                    const createdBy = comment.username || comment.pageId;
                    const isUser = !!comment.username;
                    const isPage = !!comment.pageId;
                    let name;
                    let photo;
                
                    if (isUser) {
                        const user = await User.findOne({
                            where: {
                                username: createdBy
                            },
                        });
                        name = user.firstname + " " + user.lastname;
                        photo = user.photo;
                    } else if (isPage) {
                        const page = await Page.findOne({
                            where: {
                                pageId: createdBy
                            },
                        });
                        name = page.name;
                        photo = page.photo;
                    }
                
                    return {
                        id: comment.id,
                        postId: comment.postId,
                        createdBy: createdBy,
                        commentContent: comment.commentContent,
                        Date: comment.Date,
                        isUser: isUser,
                        name: name,
                        photo: photo,
                    };
                }));
                
                return res.status(200).json({ data: comments });

            }
        } else {
            return res.status(500).json({
                message: 'server Error',
                body: req.body
            });
        }
    } catch (err) {
        console.log(err);
        return res.status(500).json({
            message: 'server Error',
            body: req.body
        });
    }

}
exports.removeLike = async (req, res, next) => {
    try {
        const { postId } = req.body;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        const existingUsername = await User.findOne({
            where: {
                username: userUsername
            },
        });
        console.log(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;")
        console.log(userUsername);
        if (existingUsername) {
            const userPostLikes = await like.findOne({
                where: { postId: postId , username: userUsername},
                
            });
            if (!userPostLikes) {
                return res.status(404).json({ error: 'like not found' });
            }
            await userPostLikes.destroy();
            return res.status(200);
        } else {
            return res.status(500).json({
                message: 'server Error',
                body: req.body
            });
        }
    } catch (err) {
        console.log(err);
        return res.status(500).json({
            message: 'server Error',
            body: req.body
        });
    }

}
exports.addLike = async (req, res, next) => {
    try {
        const { postId } = req.body;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        const existingUsername = await User.findOne({
            where: {
                username: userUsername
            },
        });
        if (existingUsername) {
            const userPostLikes = await post.findOne({
                where: { id: postId },
                include: [
                    {
                        model: like,
                        order: [['createdAt', 'DESC']],
                    },

                ],
            });
            if (!userPostLikes) {
                return res.status(404).json({ error: 'Post not found' });
            }

            if (userPostLikes.username == userUsername) {
                // Extract likes from the userPostLikes object
                await like.create({
                    postId: postId,
                    username: userUsername,
                });

                return res.status(200);
            }
            else {
                if (userPostLikes.username != userUsername) {
                    if (userPostLikes.selectedPrivacy == "Any One") {
                        await like.create({
                            postId: postId,
                            username: userUsername,
                        });
                        return res.status(200);
                    } else {
                        var userInConnections = await findIfUserInConnections(userUsername, userPostLikes.username);
                        if (userInConnections[0]) { // check if user is connected to other user
                            await like.create({
                                postId: postId,
                                username: userUsername,
                            });
                            return res.status(200);
                        }
                    }
                }
            }
        } else {
            return res.status(500).json({
                message: 'server Error',
                body: req.body
            });
        }
    } catch (err) {
        console.log(err);
        return res.status(500).json({
            message: 'server Error',
            body: req.body
        });
    }

}
exports.getPostLikes = async (req, res, next) => {
    try {
        const { postId } = req.body;
        console.log(postId)
        console.log("-----------------------------------")
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        const existingUsername = await User.findOne({
            where: {
                username: userUsername
            },
        });
        if (existingUsername) {
            const userPostLikes = await post.findOne({
                where: { id: postId },
                include: [
                    {
                        model: like,
                        order: [['createdAt', 'DESC']],
                    },

                ],
            });
            if (!userPostLikes) {
                return res.status(404).json({ error: 'Post not found' });
            }

            if (userPostLikes.username == userUsername) {
                // Extract likes from the userPostLikes object
                const likes = await Promise.all(userPostLikes.likes.map(async (like) => {
                    const createdBy = like.username || like.pageId;
                    const isUser = !!like.username;
                    const isPage = !!like.pageId;
                    var name;
                    var photo;

                    if (isUser) {
                        const user = await User.findOne({
                            where: {
                                username: createdBy
                            },
                        });
                        name = user.firstname + " " + user.lastname;
                        photo = user.photo;
                    } else if (isPage) {
                        const page = await Page.findOne({
                            where: {
                                pageId: createdBy
                            },
                        });
                        name = page.name;
                        photo = page.photo;
                    }

                    return {
                        id: like.id,
                        createdBy: createdBy,
                        isUser: isUser,
                        name: name,
                        photo: photo,
                    };
                }));

                console.log(likes);
                console.log("-----------------------------------");

                return res.status(200).json({ data: likes });
            }
        } else {
            return res.status(500).json({
                message: 'server Error',
                body: req.body
            });
        }
    } catch (err) {
        console.log(err);
        return res.status(500).json({
            message: 'server Error',
            body: req.body
        });
    }

}

exports.getPosts = async (req, res, next) => {
    try {
        const { username, pages, pagesSize } = req.body;

        var page = pages || 1;
        var pageSize = pagesSize || 10;
        const offset = (page - 1) * pageSize;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;
        const existingUsername = await User.findOne({
            where: {
                username: userUsername
            },
        });
        if (existingUsername) {
            if (userUsername == username) {
                const userPosts = await post.findAll({
                    where: { username: username },
                    order: [['postDate', 'DESC']], // Order posts by date
                    offset: offset, // Calculate the offset
                    limit: pageSize, // Number of records to retrieve
                    include: [
                        {
                            model: comment,
                            order: [['Date', 'DESC']],
                        },
                        {
                            model: like,
                            order: [['createdAt', 'DESC']],
                        },
                    ],
                });
                console.log(pageSize)
                console.log(offset)
                console.log("pppppppppppppppppppppppppppppppppp")
                console.log(userPosts.posts)
                const posts = userPosts.map(post => {
                    const isLiked = post.likes.some(like => like.username === username);

                    return {
                        id: post.id,
                        createdBy: username,
                        name: existingUsername.firstname + ' ' + existingUsername.lastname,
                        userPhoto: existingUsername.photo,
                        postContent: post.postContent,
                        selectedPrivacy: post.selectedPrivacy,
                        photo: post.photo,
                        postDate: post.postDate,
                        commentCount: post.comments.length,
                        likeCount: post.likes.length,
                        isLiked: isLiked,
                    };
                });
                console.log(posts)
                return res.status(200).json({
                    message: 'fetched',
                    posts: posts,
                });
            }
        } else {
            return res.status(500).json({
                message: 'server Error',
                body: req.body
            });
        }
    } catch (err) {
        console.log(err);
        return res.status(500).json({
            message: 'server Error',
            body: req.body
        });
    }
    return res.status(404);
}
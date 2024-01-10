const User = require("../../models/user");
const userPages = require("../../models/pages");
const pageAdmin = require("../../models/pageAdmin");
const pageEmployees = require("../../models/pageEmployees");
const { Op } = require('sequelize');
const validator = require('../validator');
const bcrypt = require('bcrypt');
const nodemailer = require('nodemailer')
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const jwt = require('jsonwebtoken');
const post = require('../../models/post');
const comment = require('../../models/comment');
const like = require('../../models/like');
const moment = require('moment');
const pageFollower = require("../../models/pageFollower");
const Page = require("../../models/pages");
const pageJobs = require("../../models/pageJobs");
const jobApplication = require("../../models/jobApplication");
const systemFields = require("../../models/systemFields");
const pageGroup = require("../../models/pageGroup");
const { notifyUser, deleteNotification } = require('../notifyUser');
const groupAdmin = require("../../models/groupAdmin");
const groupMember = require("../../models/groupMember");
const groupMessage = require("../../models/groupMessage");

exports.getMyPageGroups = async (req, res, next) => {
    try {
        const pageId = req.query.pageId;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;

        const existingEmail = await User.findOne({
            where: {
                username: userUsername
            },
        });
        if (existingEmail != null) {
            const isAdmin = await pageAdmin.findOne({
                where: {
                    username: userUsername,
                    pageId: pageId,
                    adminType: "A"
                }
            });
            if (isAdmin != null) {
                const pageGroups = await pageGroup.findAll({
                    where: {
                        pageId: pageId
                    }
                });
                return res.status(200).json({
                    message: 'Groups',
                    pageGroups: pageGroups
                });
            } else {
                return res.status(500).json({
                    message: 'You are not allowed to see this info',
                    body: req.body
                });
            }
        } else {
            return res.status(500).json({
                message: 'user not found',
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
exports.getMyPageGroupInfo = async (req, res, next) => {
    try {
        const groupId = req.query.groupId;
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;

        const existingEmail = await User.findOne({
            where: {
                username: userUsername
            },
        });
        if (existingEmail != null) {
            const group = await pageGroup.findOne({
                where: {
                    groupId: groupId
                }
            });
            if (group == null) {
                return res.status(500).json({
                    message: 'Group not found',
                    body: req.body
                });
            }
            const isAdmin = await pageAdmin.findOne({
                where: {
                    username: userUsername,
                    pageId: group.pageId,
                    adminType: "A"
                }
            });
            if (isAdmin != null) {

                const groupAdmins = await groupAdmin.findAll({
                    where: {
                        groupId: groupId
                    }
                });
                const groupMembers = await groupMember.findAll({
                    where: {
                        groupId: groupId
                    }
                });
                return res.status(200).json({
                    message: 'Group',
                    groupAdmins: groupAdmins,
                    groupMembers: groupMembers,
                });
            } else {
                const isUserAdminInGroup = await groupAdmin.findOne({
                    where: {
                        groupId: groupId,
                        username: userUsername,
                    }
                });
                if (isUserAdminInGroup != null) {
                    const groupAdmins = await groupAdmin.findAll({
                        where: {
                            groupId: groupId
                        }
                    });
                    const groupMembers = await groupMember.findAll({
                        where: {
                            groupId: groupId
                        }
                    });
                    return res.status(200).json({
                        message: 'Group',
                        groupAdmins: groupAdmins,
                        groupMembers: groupMembers,
                    });
                } else {
                    const isUserMemberInGroup = await groupMember.findOne({
                        where: {
                            groupId: groupId,
                            username: userUsername,
                        }
                    });
                    if (isUserMemberInGroup != null) {
                        const groupAdmins = await groupAdmin.findAll({
                            where: {
                                groupId: groupId
                            }
                        });
                        const groupMembers = await groupMember.findAll({
                            where: {
                                groupId: groupId
                            }
                        });
                        return res.status(200).json({
                            message: 'Group',
                            groupAdmins: groupAdmins,
                            groupMembers: groupMembers,
                        });
                    } else {
                        return res.status(500).json({
                            message: 'You are not allowed to see this info',
                            body: req.body
                        });
                    }
                }
            }
        } else {
            return res.status(500).json({
                message: 'user not found',
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
exports.getMyPageGroupMessages = async (req, res, next) => {
    try {
        const groupId = req.query.groupId;
        var page = parseInt(req.query.page) || 1;
        var pageSize = parseInt(req.query.pageSize) || 10;
        const offset = (page - 1) * pageSize;
        console.log("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
        const authHeader = req.headers['authorization']
        const decoded = jwt.verify(authHeader.split(" ")[1], process.env.ACCESS_TOKEN_SECRET);
        var userUsername = decoded.username;

        const existingEmail = await User.findOne({
            where: {
                username: userUsername
            },
        });
        if (existingEmail != null) {
            const group = await pageGroup.findOne({
                where: {
                    groupId: groupId
                }
            });
            if (group == null) {
                return res.status(500).json({
                    message: 'Group not found',
                    body: req.body
                });
            }
            const isAdmin = await pageAdmin.findOne({
                where: {
                    username: userUsername,
                    pageId: group.pageId,
                    adminType: "A"
                }
            });
            if (isAdmin != null) {

                const groupMessages = await groupMessage.findAll({
                    where: {
                        groupId: groupId
                    },
                    order: [['createdAt', 'DESC']], // Order by created date in descending order
                    offset: offset,
                    limit: pageSize,
                    include: [
                        {
                            model: User,
                            attributes: ['username', 'firstName', 'lastName', 'photo'],
                        },
                    ],
                });
                return res.status(200).json({
                    message: 'Group',
                    groupMessages: groupMessages,
                });
            } else {
                const isUserAdminInGroup = await groupAdmin.findOne({
                    where: {
                        groupId: groupId,
                        username: userUsername,
                    }
                });
                if (isUserAdminInGroup != null) {
                    const groupMessages = await groupMessage.findAll({
                        where: {
                            groupId: groupId
                        },
                        order: [['createdAt', 'DESC']], // Order by created date in descending order
                        offset: offset,
                        limit: pageSize,
                        include: [
                            {
                                model: User,
                                attributes: ['username', 'firstName', 'lastName', 'photo'],
                            },
                        ],
                    });
                    return res.status(200).json({
                        message: 'Group',
                        groupMessages: groupMessages,
                    });
                } else {
                    const isUserMemberInGroup = await groupMember.findOne({
                        where: {
                            groupId: groupId,
                            username: userUsername,
                        }
                    });
                    if (isUserMemberInGroup != null) {
                        const groupMessages = await groupMessage.findAll({
                            where: {
                                groupId: groupId
                            },
                            order: [['createdAt', 'DESC']], // Order by created date in descending order
                            offset: offset,
                            limit: pageSize,
                            include: [
                                {
                                    model: User,
                                    attributes: ['username', 'firstName', 'lastName', 'photo'],
                                },
                            ],
                        });
                        return res.status(200).json({
                            message: 'Group',
                            groupMessages: groupMessages,
                        });
                    } else {
                        return res.status(500).json({
                            message: 'You are not allowed to see this info',
                            body: req.body
                        });
                    }
                }
            }
        } else {
            return res.status(500).json({
                message: 'user not found',
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
const User = require("../../../models/user");
const post = require('../../../models/post');
const Page = require("../../../models/pages");
const pageJobs = require("../../../models/pageJobs");
const jobApplication = require("../../../models/jobApplication");
const pageGroup = require("../../../models/pageGroup");
const messages = require("../../../models/messages");
const activeUsers = require("../../../models/activeUsers");
const groupMeeting = require("../../../models/groupMeeting");


exports.getActiveUsers = async (req, res, next) => {
    var username = req.user.username;
    var existingUsername = await User.findOne({
        where: {
            username: username,
            status: null,
            type: "Admin"
        }
    });
    if (existingUsername != null) {
        var users = await activeUsers.findAll({
        });
        return res.status(200).json({
            message: 'users',
            users: users,
        });
    } else {
        return res.status(500).json({
            message: 'Invalid email',
            body: req.body
        });
    }

}
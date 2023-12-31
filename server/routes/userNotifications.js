const express=require('express');
const router=express.Router();
const notifications = require('../controller/notifications')
const { authenticateToken } = require('../controller/authController');







router.get('/notifications',authenticateToken, notifications.getNotifications);
router.post('/notify', notifications.notify);
router.post('/deleteNotification', notifications.deleteNotification);
router.get('/notificationsAuth',authenticateToken, notifications.getevents);
module.exports=router;
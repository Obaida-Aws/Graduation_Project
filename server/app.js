
const express = require('express');
const bodyParser = require('body-parser');
const userRoutes = require('./routes/user');
const sequelize=require('./util/database');

var cors = require('cors');
const app = express();

app.use(express.json({ limit: '100mb' }));
app.use(cors()); 
app.use(bodyParser.json());
app.use(express.static('messageImages'));
app.use(express.static('messageVideos'));

app.use(express.static('images'));
app.use(express.static('cvs'));



// Use feed routes
app.use('/user', userRoutes);

//{force:true}
sequelize.sync().then(result =>{
    console.log(result);
    app.listen(3000);
  
}).catch(err=>{
    console.log(err);
    

});

/*
const express=require('express');

const user=require('./models/user');
const TempUser=require('./models/tempUser');
const forgetpasswordController=require('./models/forgetPasswordCode');
const changeEmail=require('./models/changeEmail');
const workExperience=require('./models/workExperience');
const EducationLevel=require('./models/educationLevel');
const pages=require('./models/pages');
const pageAdmin=require('./models/pageAdmin');
const sentConnection =require('./models/sentConnection');
const connections =require('./models/connections');
const post =require('./models/post');
const comment =require('./models/comment');
const like =require('./models/like');
const notifications =require('./models/notifications');
const activeUsers =require('./models/activeUsers');
const messages =require('./models/messages');
const pageFollower =require('./models/pageFollower');
const pageEmployees =require('./models/pageEmployees');
const pageJobs =require('./models/pageJobs');
const jobApplication =require('./models/jobApplication');
const userTasks =require('./models/userTasks');
const systemFields =require('./models/systemFields')

//const queries =require('./models/queries.js');




const createTestData =require('./models/createTestData');

//const bodyParser=require('body-parser');

const sequelize=require('./util/database');

const app=express();

//{force:true}
sequelize.sync().then(result =>{
    console.log(result);
    app.listen(3000);
  
}).catch(err=>{
    console.log(err);
    

});*/
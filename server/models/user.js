const Sequelize=require('sequelize');

const sequelize=require('../util/database');
const User=sequelize.define('user',{
    username:{
        type:Sequelize.STRING,
        allowNull:false,
        primaryKey:true

    },
    firstname: {type:Sequelize.STRING,allowNull:false},
    lastname:  {type:Sequelize.STRING,allowNull:false},
    email: {
        type: Sequelize.STRING,
        allowNull:false,
    },
    password: {
        type:Sequelize.STRING(1000),
        allowNull:false
    },
    bio: {
        type:Sequelize.STRING,
        allowNull:true
    },
    country:{
        type:Sequelize.STRING,
        allowNull:true
    },
    address:{
        type:Sequelize.STRING,
        allowNull:true
    },
    phone:{
        type:Sequelize.STRING,
        allowNull:false
    },
    dateOfBirth:{
        type:Sequelize.DATEONLY,
        allowNull:false
    },
    Gender:{
        type:Sequelize.STRING,
        allowNull:true

    },
    Fields:{
        type:Sequelize.STRING(6000),
        allowNull:true

    },
    photo:{
        type:Sequelize.STRING,
        allowNull:true
    },
    coverImage:{
        type:Sequelize.STRING,
        allowNull:true
    },
    cv:{
        type:Sequelize.STRING,
        allowNull:true
    },
    token:{
        type:Sequelize.STRING(2000),
        allowNull:true
    },
    status:{
        type:Sequelize.BOOLEAN,
        allowNull:true
    },
    type:{
        type:Sequelize.STRING,
        allowNull:true
    },

});



module.exports=User;
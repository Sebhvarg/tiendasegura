const mongoose = require('mongoose');
const { Schema, model, Types } = mongoose;

const userSchema = new Schema(
    {
        name: { type: String, required: true },
        lastName: { type: String, required: true },
        username: { type: String, required: true, unique: true },
        email: { type: String, required: true, unique: true },
        address: { type: String, required: true },
        phone: { type: String, required: true },
        password: { type: String, required: true },
        DateOfBirth: { type: Date, required: true },
        userType: { type: String, enum: ['admin', 'customer', 'seller'], required: true },
        createdAt: { type: Date, default: Date.now },
        updatedAt: { type: Date, default: Date.now },
        isActive: { type: Boolean, default: true },
    },
    { timestamps: true }
);

const User = model('User', userSchema);

module.exports = User;
const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  phoneNumber: {
    type: String,
    required: true,
    unique: true
  },
  firstName: {
    type: String,
    required: true
  },
  lastName: {
    type: String,
    required: true
  },
  email: String,
  birthDate: Date,
  gender: {
    type: String,
    enum: ['Erkek', 'Kadin', 'Diger']
  },
  isVerified: {
    type: Boolean,
    default: false
  }
});

module.exports = mongoose.model('User', userSchema);

require('dotenv').config();
const express = require('express');
const router = express.Router();
const twilio = require('twilio');
const User = require('../models/User');

const client = twilio(process.env.TWILIO_ACCOUNT_SID, process.env.TWILIO_AUTH_TOKEN);
const verifyService = client.verify.v2.services(process.env.TWILIO_SERVICE_SID);
const verificationCodes = new Map(); // Geçici kod saklama

// Telefon numarası kontrolü ve SMS gönderimi
router.post('/check-phone', async (req, res) => {
  try {
    const { phoneNumber } = req.body;
    
    // Telefon numarası formatı kontrolü
    if (!phoneNumber.match(/^\+?[1-9]\d{1,14}$/)) {
      return res.status(400).json({
        success: false,
        message: "Geçersiz telefon numarası formatı"
      });
    }

    // Kullanıcı kontrolü
    const existingUser = await User.findOne({ phoneNumber });
    
    // Twilio ile doğrulama başlat
    const verification = await verifyService.verifications.create({
      to: phoneNumber,
      channel: 'sms'
    });

    res.json({
      success: true,
      exists: !!existingUser,
      status: verification.status,
      message: "Doğrulama kodu gönderildi"
    });
  } catch (error) {
    console.error('SMS gönderme hatası:', error);
    res.status(500).json({
      success: false,
      message: "SMS gönderilirken bir hata oluştu",
      error: error.message
    });
  }
});

// Doğrulama kodu kontrolü
router.post('/verify-code', async (req, res) => {
  try {
    const { phoneNumber, code } = req.body;
    
    // Twilio ile doğrulama kontrolü
    const verificationCheck = await verifyService.verificationChecks.create({
      to: phoneNumber,
      code: code
    });

    if (verificationCheck.status !== 'approved') {
      return res.status(400).json({
        success: false,
        message: "Geçersiz doğrulama kodu",
        status: "failed"
      });
    }

    // Başarılı doğrulama
    const user = await User.findOne({ phoneNumber });
    const isRegistered = !!user;

    res.json({
      success: true,
      isRegistered,
      status: "approved",
      message: "Doğrulama başarılı"
    });
  } catch (error) {
    console.error('Doğrulama hatası:', error);
    res.status(500).json({
      success: false,
      message: "Doğrulama sırasında bir hata oluştu",
      error: error.message
    });
  }
});

// Kullanıcı kaydı tamamlama
router.post('/complete-registration', async (req, res) => {
  try {
    const { phoneNumber, firstName, lastName, email, birthDate, gender } = req.body;

    // Zorunlu alan kontrolü
    if (!phoneNumber || !firstName || !lastName) {
      return res.status(400).json({
        success: false,
        message: "Telefon numarası, isim ve soyisim zorunludur"
      });
    }

    // Kullanıcı oluştur
    const user = new User({
      phoneNumber,
      firstName,
      lastName,
      email,
      birthDate,
      gender,
      isVerified: true
    });

    await user.save();

    res.json({
      success: true,
      user: {
        phoneNumber: user.phoneNumber,
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        birthDate: user.birthDate,
        gender: user.gender,
        isVerified: user.isVerified
      },
      message: "Kayıt başarıyla tamamlandı"
    });
  } catch (error) {
    console.error('Kayıt hatası:', error);
    res.status(500).json({
      success: false,
      message: "Kayıt tamamlanırken bir hata oluştu",
      error: error.message
    });
  }
});

module.exports = router;

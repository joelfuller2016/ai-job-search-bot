const express = require('express');
const jobRoutes = require('./jobs');
const applicationRoutes = require('./applications');
const interviewRoutes = require('./interviews');
const analyticsRoutes = require('./analytics');
const settingsRoutes = require('./settings');
const authRoutes = require('./auth');

const router = express.Router();

// Route definitions
router.use('/jobs', jobRoutes);
router.use('/applications', applicationRoutes);
router.use('/interviews', interviewRoutes);
router.use('/analytics', analyticsRoutes);
router.use('/settings', settingsRoutes);
router.use('/auth', authRoutes);

// API info endpoint
router.get('/', (req, res) => {
  res.json({
    name: 'AI Job Search Bot API',
    version: '1.0.0',
    description: 'API for automated job search and application system',
    endpoints: {
      jobs: '/api/jobs',
      applications: '/api/applications',
      interviews: '/api/interviews',
      analytics: '/api/analytics',
      settings: '/api/settings',
      auth: '/api/auth'
    }
  });
});

module.exports = router;
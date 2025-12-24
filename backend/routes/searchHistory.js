const express = require('express');
const router = express.Router();
const SearchHistory = require('../models/searchHistory');

router.get('/:clientId', async (req, res, next) => {
  try {
    const history = await SearchHistory.find({
      client: req.params.clientId
    }).sort({ createdAt: -1 });

    res.json(history);
  } catch (err) {
    next(err);
  }
});

module.exports = router;

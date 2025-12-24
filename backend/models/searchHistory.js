const mongoose = require('mongoose');

const searchHistorySchema = new mongoose.Schema(
  {
    client: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Client',
      required: true
    },
    query: {
      type: String,
      required: true
    }
  },
  { timestamps: true }
);

module.exports = mongoose.model('SearchHistory', searchHistorySchema);

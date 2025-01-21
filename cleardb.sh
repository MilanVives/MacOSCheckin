#!/bin/bash
curl -X POST \
  -H "x-cleanup-key: your-very-long-secret-key-here" \
  https://checkin.vives.live/api/v1/maintenance/d41d8cd98f00b204e9800998ecf8427e/cleanup
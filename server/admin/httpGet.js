'use strict';

module.exports = async () => {
  return {
    statusCode: 200,
    body: JSON.stringify(
      {
        message: 'httpGET executed successfully!',
      },
      null,
      2
    ),
  };
}
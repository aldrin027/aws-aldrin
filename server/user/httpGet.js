'use strict';

module.exports.handler = async () => {
  return {
    statusCode: 200,
    body: JSON.stringify(
      {
        message: `httpGET executed successfully!`,
      },
      null,
      2
    ),
  };
}
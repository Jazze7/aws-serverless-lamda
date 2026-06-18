const { DynamoDBClient } = require("@aws-sdk/client-dynamodb");
const {
  DynamoDBDocumentClient,
  GetCommand,
  PutCommand,
} = require("@aws-sdk/lib-dynamodb");

const client = new DynamoDBClient({});
const ddb = DynamoDBDocumentClient.from(client);

const TABLE = process.env.TABLE;

exports.handler = async (event) => {
  console.log("EVENT:", JSON.stringify(event));

  try {
    // ✅ Support both HTTP API v2 and REST API v1
    const method =
      event.requestContext?.http?.method || event.httpMethod;

    const path =
      event.requestContext?.http?.path || event.path;

    // =========================
    // ROOT ENDPOINT (GET /)
    // =========================
    if (method === "GET" && path === "/") {
      return response(200, {
        message: "Hello from serverless function",
        timestamp: new Date().toISOString(),
      });
    }

    // =========================
    // WRITE ENDPOINT (POST /write)
    // =========================
    if (method === "POST" && path === "/write") {
      const body = JSON.parse(event.body || "{}");

      if (!body.id) {
        return response(400, { error: "id is required" });
      }

      const item = {
        id: body.id,
        data: body.data || "No data provided",
        createdAt: new Date().toISOString(),
      };

      await ddb.send(
        new PutCommand({
          TableName: TABLE,
          Item: item,
        })
      );

      return response(200, {
        message: "Item saved successfully",
        item,
      });
    }

    // =========================
    // READ ENDPOINT (GET /read?id=123)
    // =========================
    if (method === "GET" && path === "/read") {
      const id = event.queryStringParameters?.id;

      if (!id) {
        return response(400, { error: "id query param required" });
      }

      const result = await ddb.send(
        new GetCommand({
          TableName: TABLE,
          Key: { id },
        })
      );

      if (!result.Item) {
        return response(404, { error: "Item not found" });
      }

      return response(200, result.Item);
    }

    return response(404, { error: "Route not found" });

  } catch (error) {
    console.error("ERROR:", error);
    return response(500, { error: error.message });
  }
};

function response(statusCode, body) {
  return {
    statusCode,
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(body),
  };
}
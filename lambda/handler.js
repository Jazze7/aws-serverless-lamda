exports.handler = async (event)=>{
return{
    statusCode:200,
    ContentType: 'application/json',
    body:JSON.stringify({
        message: "Hello from serverless function",
        timestamp: new Date().toISOString(),
    }),
};
};
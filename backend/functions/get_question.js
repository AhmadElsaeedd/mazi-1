
const { Configuration,OpenAIApi }= require("openai");
const configuration = new Configuration({
  apiKey: functions.config().openai.key,
});
const openai = new OpenAIApi(configuration);

const corsOptions = {
    origin: true,
  };

//have to set the openai environment variable

exports.GetQuestion = functions.region("asia-east2").https.onRequest((req, res) => {
    cors(corsOptions)(req, res, async () => {
        //receive a request

        //send back a response
      });
  });


module.exports = GetQuestion;
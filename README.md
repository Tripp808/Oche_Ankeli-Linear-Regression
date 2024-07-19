# Wine Prediction App

This Flutter app predicts wine quality using a machine learning model hosted on a FastAPI server.

## API Endpoint

The API endpoint for prediction is publicly available at: https://oche-ankeli-linear-regression-summative.onrender.com/predict
This API predicts wine quality based on multiple chemical properties. 

## Demo Video 
Here's the demo video: https://www.loom.com/share/de8e29e703054668b9ec581a70fe1acc?sid=c36dfc54-c9ed-4a3c-ba30-e533695208f6

You can test the API using Postman. Create a POST request, enter the URL above. In the body, select raw and JSON and enter the JSON object: {
    "features": [13.0, 2.0, 2.0, 19.5, 86.0, 2.2, 2.1, 0.3, 1.6, 3.0, 1.0, 3.4, 1050.0]
}
The response should be: 
{
    "prediction": 0.38537245448782675
}

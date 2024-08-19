
from fastapi import FastAPI
import uvicorn
import pandas as pd
import joblib



app = FastAPI(debug=True)


@app.get("/")
def read_root():
    return {"Hello": "Universe"}

    
model_filename = "C:/Users/IVAN/Desktop/projects/malnudetect/assets/models/new_svm_with_grid_search.joblib"
loaded_pipeline = joblib.load(model_filename)

@app.get("/Predict")
def predict(Sex: str, Age: str, Height: str, Weight: str):

        # Convert Age to integer and Height/Weight to float
    try:
        Age = int(Age)
        Height = float(Height)
        Weight = float(Weight)
    except ValueError:
        return {"error": "Invalid input. Age must be an integer, Height and Weight must be numeric."}

    # Convert Sex to numeric code
    if Sex.lower() == "male":
        sex_code = 1
    elif Sex.lower() == "female":
        sex_code = 0
    else:
        return {"error": "Invalid input for Sex. Use 'male' or 'female'."}

    if Sex.lower() == "male":
        sex_code = 1
    else:
        sex_code = 0



    example_input = {
        "Sex": sex_code,
        "Age": Age,
        "Height": Height,
        "Weight": Weight,
    }


    input_df = pd.DataFrame([example_input])

    # Ensure column order matches the training data
    input_df = input_df[['Sex', 'Age', 'Height', 'Weight']]

    # Make prediction
    prediction = loaded_pipeline.predict(input_df)[0]

    # Return prediction
    return {"Detected as": prediction}

    
    

if  __name__ == "__main__":
    uvicorn.run(app, host= "0.0.0.0", port= 8000)





###################################################################################################

    # data = [[sex_code, Age, Height,Weight]]


    # label_encoder = LabelEncoder()


    # labels= ['Overweight' 'Stunting' 'Underweight' 'Wasting']

    # label_encoder.fit_transform(labels)
    
    # xvaluetopredict =  np.array(data, dtype=float)

    # yprediction = firstmodel.predict(xvaluetopredict)


    # y_new_pred = label_encoder.inverse_transform(yprediction)

    # return {"Detected as "+ y_new_pred[0]}


    # with open(model_path, 'rb') as model_file:
    #     model = pickle.load(model_file)

    # with open(encoder_path, 'rb') as encoder_file:
    #     label_encoder = pickle.load(encoder_file)


     # Convert the example input to a DataFrame

    # input_df = pd.DataFrame([example_input])

    # # Ensure the column order matches the training data
    # input_df = input_df[['Sex', 'Age', 'Height', 'Weight']]

    # # Make predictions using the loaded pipeline
    # prediction = model.predict(input_df)[0]

    # # Transform the prediction back to its original label
    # original_label = label_encoder.inverse_transform([prediction])[0]

    # # Get the index of the predicted label
    # prediction_index = list(label_encoder.classes_).index(original_label)

    # return {
    #     "Predicted Status": original_label,
    #     "Index of Predicted Status": prediction_index
    # }




##########################################################################################################
    

# from fastapi import FastAPI, HTTPException
# import uvicorn
# import pickle
# import numpy as np
# import pandas as pd
# import logging

# # Initialize the FastAPI app
# app = FastAPI(debug=True)

# # Define the paths to the model and label encoder
# model_path = "C:/Users/IVAN/Desktop/projects/malnudetect/assets/models/svm_with_grid_search.pkl"
# encoder_path = "C:/Users/IVAN/Desktop/projects/malnudetect/assets/models/svm_grid_search_label_encoder.pkl"

# # Load the model and label encoder
# try:
#     with open(model_path, 'rb') as model_file:
#         model = pickle.load(model_file)

#     with open(encoder_path, 'rb') as encoder_file:
#         label_encoder = pickle.load(encoder_file)
    
#     # Verify the classes in the label encoder
#     logging.info(f"Classes in the Label Encoder: {label_encoder.classes_}")

# except Exception as e:
#     logging.error(f"Error loading model or label encoder: {e}")
#     raise

# @app.get("/")
# def read_root():
#     return {"Hello": "Universe"}

# @app.get("/Predict")
# def predict(Sex: str, Age: str, Height: str, Weight: str):
#     try:
#         if Sex.lower() == "male":
#             sex_code = 1
#         else:
#             sex_code = 0

#         # Create input data as a DataFrame
#         example_input = {
#             "Sex": sex_code,
#             "Age": Age,
#             "Height": Height,
#             "Weight": Weight,
#         }

#         input_df = pd.DataFrame([example_input])
#         input_df = input_df[['Sex', 'Age', 'Height', 'Weight']]

#         # Make predictions using the loaded model
#         prediction = model.predict(input_df)[0]

#         # Check the prediction
#         logging.info(f"Prediction: {prediction}")

#         # Transform the prediction back to its original label
#         original_label = label_encoder.inverse_transform([prediction])[0]

#         # Get the index of the predicted label
#         prediction_index = list(label_encoder.classes_).index(original_label)

#         return {
#             "Predicted Status": original_label,
#             "Index of Predicted Status": prediction_index
#         }

#     except Exception as e:
#         logging.error(f"Error during prediction: {e}")
#         raise HTTPException(status_code=500, detail="Internal Server Error")

# if __name__ == "__main__":
#     uvicorn.run(app, host="0.0.0.0", port=8000)











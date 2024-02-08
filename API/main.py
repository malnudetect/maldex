
from fastapi import FastAPI
import uvicorn
import pickle
import numpy as np
from sklearn.preprocessing import LabelEncoder



app = FastAPI(debug=True)
pklocation = "C:/Users/IVAN/Desktop/projects/malnudetect/assets/models/svm_model.pkl"


@app.get("/")
def read_root():
    return {"Hello": "Universe"}


@app.get("/Predict")
def predict(Sex: str, Age: str, Height: str, Weight: str):
    
    
    if Sex.lower() == "male":
        sex_code = 1
    else:
        sex_code = 0
    
    model= pickle.load(open("C:/Users/IVAN/Desktop/projects/malnudetect/assets/models/svm_model.pkl", "rb"))
    
    data = [[sex_code, Age, Height,Weight]]


    label_encoder = LabelEncoder()


    labels= ["wasting", "overweight","stunting","underweight"]

    label_encoder.fit_transform(labels)
    
    xvaluetopredict =  np.array(data, dtype=float)

    yprediction = model.predict(xvaluetopredict)


    y_new_pred = label_encoder.inverse_transform(yprediction)

    return {"Detected as "+ y_new_pred[0]}



if  __name__ == "__main__":
    uvicorn.run(app)



from ultralytics import YOLO
from fastapi import FastAPI, UploadFile, File, HTTPException, Response, status
import uuid
import boto3
from PIL import Image
import os
import shutil
import io

app = FastAPI()

s3 = boto3.client('s3')
bucket_name = 'lambda-bucket-ai-model'

tmp_dir = 'tmp'

@app.get("/")
def read_root():
    return {"message": "Hello Everybody! My name is Giao. This repository in Development."}

@app.post("/detect")
async def upload_model(file: UploadFile = File(...)):
    model = YOLO("yolov8n-pose.pt")

    if not os.path.exists(tmp_dir):
        os.makedirs(tmp_dir)
        
    file_path = os.path.join(tmp_dir, file.filename)
    
    with open(file_path, "wb") as f:
        shutil.copyfileobj(file.file, f)
    
    results = model.predict(source=file_path, save=True, project="/tmp", name="predict")
    
    for result in results:
        path_dir = result.save_dir + "/" + file.filename
        
    s3_key = f'fastapi/{file.filename}'  
    
    img = Image.open(path_dir)

    out_img = io.BytesIO()
    img.save(out_img, 'PNG')
    out_img.seek(0)

    s3.put_object(Bucket=bucket_name, Key=s3_key, Body=out_img, ContentType='image/png')
    
    os.remove(file_path)
    os.rmdir(tmp_dir)
    
    return {
        "url": f'https://{bucket_name}.s3.amazonaws.com/{s3_key}'
    }
 
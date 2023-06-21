import boto3
import json

def lambda_handler(event, context):
    # Obtener información del archivo JSON desde el evento de Lambda
    json_data = event['Records'][0]['s3']['object']['key']
    
    # Configurar cliente de Amazon S3
    s3 = boto3.client('s3')
    
    # Descargar el archivo JSON desde S3
    response = s3.get_object(Bucket='awslambda-hacked-bucket', Key=json_data)
    
    # Leer el contenido del archivo JSON
    json_content = response['Body'].read().decode('utf-8')
    
    # Procesar el contenido JSON
    data = json.loads(json_content)
    
    # Crear un cliente de DynamoDB
    dynamodb = boto3.resource('dynamodb')
    
    # Seleccionar la tabla de DynamoDB
    table = dynamodb.Table('clientData')
    
    # Insertar los datos en la tabla de DynamoDB
    for item in data:
        table.put_item(Item=item)
    
    # Retornar una respuesta
    return {
        'statusCode': 200,
        'body': 'Data inserted successfully'
    }
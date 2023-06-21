provider "aws" {
  region = "ca-central-1"
}

resource "aws_dynamodb_table" "clientData" {
  name           = "clientData"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"
  range_key      = "name"
  attribute {
    name = "id"
    type = "S"
  }
  attribute {
    name = "name"
    type = "S"
  }
  tags = {
    Environment = "SuperTest"
  }
}

resource "aws_s3_bucket" "awslambda-hacked-bucket" {
  bucket = "awslambda-hacked-bucket"

  tags = {
    Name        = "HackedTest"
    Environment = "SuperTest"
  }
}

resource "aws_lambda_function" "data_updater" {
  function_name    = "data_updater"
  role             = aws_iam_role.LambdaAdminRole.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.9"
  filename         = "../lambda/lambda.zip"
  source_code_hash = filebase64sha256("../lambda/lambda.zip")

  timeout = 60  # Ajusta el tiempo límite de ejecución según tus necesidades
}


resource "aws_iam_role" "LambdaAdminRole" {
  name = "LambdaAdminRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb_policy_attachment" {
  role       = aws_iam_role.LambdaAdminRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_s3_policy_attachment" {
  role       = aws_iam_role.LambdaAdminRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

data "aws_iam_policy_document" "lambda_dynamodb_policy" {
  statement {
    actions   = ["dynamodb:PutItem", "dynamodb:GetItem"]
    resources = ["arn:aws:dynamodb:*:*:table/clientData"]
  }
}

resource "aws_iam_policy" "lambda_dynamodb_policy" {
  name   = "lambda_dynamodb_policy"
  policy = data.aws_iam_policy_document.lambda_dynamodb_policy.json
}

resource "aws_iam_role_policy_attachment" "lambda_custom_dynamodb_policy_attachment" {
  role       = aws_iam_role.LambdaAdminRole.name
  policy_arn = aws_iam_policy.lambda_dynamodb_policy.arn
}

data "aws_iam_policy_document" "lambda_s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.awslambda-hacked-bucket.arn}/*"]
  }
}

resource "aws_iam_policy" "lambda_s3_policy" {
  name   = "lambda_s3_policy"
  policy = data.aws_iam_policy_document.lambda_s3_policy.json
}

resource "aws_iam_role_policy_attachment" "lambda_custom_s3_policy_attachment" {
  role       = aws_iam_role.LambdaAdminRole.name
  policy_arn = aws_iam_policy.lambda_s3_policy.arn
}

resource "aws_lambda_permission" "s3_bucket_permission" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.data_updater.arn
  principal     = "s3.amazonaws.com"
  source_arn    = "${aws_s3_bucket.awslambda-hacked-bucket.arn}"
}

resource "aws_s3_bucket_notification" "lambda_trigger" {
  bucket = "awslambda-hacked-bucket"

  lambda_function {
    lambda_function_arn = aws_lambda_function.data_updater.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = ""
    filter_suffix       = ".json"
  }
}


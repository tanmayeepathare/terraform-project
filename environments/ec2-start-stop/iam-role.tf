#AWS IAM ROle we need to create the role for the lambda service and neeed to add the ec2 permsiion mens policy will be created for the ec2 

resource "aws_iam_role" "ec2_scheduler_tf_role" {
  name = "${var.project_name}-role-tf"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Principal": {
                "Service": [
                    "lambda.amazonaws.com"
                ]
            }
        }
    ]
})

}


# AWS IAM Polcies 

resource "aws_iam_policy" "ec2_scheduler_policy" {
  name        = "${var.project_name}-policy-tf"
  description = "IAM Policy for the aws ec2 access for lamabdas3"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeInstances"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:StartInstances",
        "ec2:StopInstances"
      ],
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "ec2:ResourceTag/AutoSchedule": "true"
        }
      }
    }
  ]
})
}

# POLICY ATTACHMENT

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.ec2_scheduler_tf_role.name
  policy_arn = aws_iam_policy.ec2_scheduler_policy.arn
}

#AWS Lambda VPC networking policy

resource "aws_iam_role_policy_attachment" "lambda_vpc_access" {
  role = aws_iam_role.ec2_scheduler_tf_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}
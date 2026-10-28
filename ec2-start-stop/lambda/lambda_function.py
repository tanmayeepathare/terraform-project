import boto3
import json

ec2 = boto3.client("ec2")


def lambda_handler(event, context):

    print(f"Received Event: {json.dumps(event)}")

    action = event.get("action")

    # Validate action
    if action not in ["start", "stop"]:
        return {
            "status": "failed",
            "message": "Invalid action. Use start or stop."
        }

    try:

        # Fetch EC2 instances using tag
        response = ec2.describe_instances(
            Filters=[
                {
                    "Name": "tag:AutoSchedule",
                    "Values": ["true"]
                }
            ]
        )

        instance_ids = []

        for reservation in response["Reservations"]:

            for instance in reservation["Instances"]:

                instance_id = instance["InstanceId"]

                state = instance["State"]["Name"]

                print(f"Instance: {instance_id}, State: {state}")

                # START LOGIC
                if action == "start" and state == "stopped":
                    instance_ids.append(instance_id)

                # STOP LOGIC
                elif action == "stop" and state == "running":
                    instance_ids.append(instance_id)

        # No matching instances
        if not instance_ids:

            return {
                "status": "success",
                "message": f"No eligible instances found for action: {action}"
            }

        print(f"Action: {action}")
        print(f"Target Instances: {instance_ids}")

        # START INSTANCES
        if action == "start":

            ec2.start_instances(
                InstanceIds=instance_ids
            )

            return {
                "status": "success",
                "message": f"Started instances: {instance_ids}"
            }

        # STOP INSTANCES
        elif action == "stop":

            ec2.stop_instances(
                InstanceIds=instance_ids
            )

            return {
                "status": "success",
                "message": f"Stopped instances: {instance_ids}"
            }

    except Exception as e:

        print(f"Error: {str(e)}")

        return {
            "status": "failed",
            "error": str(e)
        }


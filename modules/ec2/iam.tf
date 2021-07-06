data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "merc_stage_server" {
  name               = "${local.server_name}-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
  tags               = var.global_tags
}

resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.merc_stage_server.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "service_policy" {
  role       = aws_iam_role.merc_stage_server.name
  policy_arn = var.service_policy_arn
}

resource "aws_iam_instance_profile" "merc_stage_server" {
  name = "${local.server_name}-instance-profile"
  role = aws_iam_role.merc_stage_server.name
  tags = var.global_tags
}


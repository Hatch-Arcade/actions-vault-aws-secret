Usage:

        # This will export aws credentials to environment variables
        - name: fetch aws secret
          uses: Hatch-Arcade/actions-vault-aws-secret@v1
          with:
            vault_address: https://vault.example.com
            vault_aws_secret_backend_role: vault_aws_secret
            assume_role_arn: arn:aws:iam::123456789:role/github_actions
            role_id: xxxxxxxxxxxxxxxxx
            secret_id: xxxxxxxxxxxxxxxxxxx

        - name: Configure AWS credentials
          uses: aws-actions/configure-aws-credentials@v1
          with:
            aws-region: eu-west-1

        # use the exported aws credentials to login to ecr
        - name: Login to Amazon ECR
          id: login-ecr
          uses: aws-actions/amazon-ecr-login@v1

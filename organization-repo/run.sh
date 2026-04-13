/Users/abambah/homebrew/bin/terraform fmt 
git add .
git commit -m "adding changes to the Base infra" . 
git push 
/Users/abambah/homebrew/bin/terraform init
/Users/abambah/homebrew/bin/terraform plan -var-file=tf-dev.tfvars -out=tf.out
/Users/abambah/homebrew/bin/terraform apply "tf.out"
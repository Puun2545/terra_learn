##################################################################################
# RESOURCES
##################################################################################

#Random ID
resource "random_integer" "rand" {
  min = 100
  max = 99999
}

module "s3_bucket" {
  source          = "./modules"
  bucket_name     = "puun-npa-2024-${random_integer.rand.result}"
  tags = merge(local.common_tags, { Name = "${var.cName}-web-bucket" })
}

resource "aws_s3_object" "image" {
  bucket = module.s3_bucket.name
  key    = "testimage.jpg"  
  source = "./images/memes.jpeg" 
}


locals {


  bucket_name= lower(replace("${var.org}-${var.domain}-${var.region}","_","-"))
  prefix_layers = {

    silver = "silver/"
    golden = "golden/"
    bronze = "bronze/"


  }

  env_keys    = keys(aws_s3_bucket.data_lake)  #id
  layer_keys  = keys(local.prefix_layers)       

  # Cartesian product: list of [env, layer] tuples
  env_layer_pairs = setproduct(local.env_keys, local.layer_keys)

  # Build "env:layer" => { bucket_id, object_key }
  layer_objects = {
    for pair in local.env_layer_pairs :
    "${pair[0]}:${pair[1]}" => {
      bucket_id  = aws_s3_bucket.data_lake[pair[0]].id
      object_key = local.prefix_layers[pair[1]]
    }
  }
}






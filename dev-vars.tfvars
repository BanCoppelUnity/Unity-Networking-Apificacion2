region = "us-east-1"

vpc = {
  cidr_block = "10.209.10.0/23"
  name       = "ApificacionNonProdDev"
}

environment = "dev"

tags = {
  "Application Role" = "networking",
  "Project"          = "Unity",
  "Owner"            = "Brenda Pichardo",
  "Cost Center"      = "Pendiente",
  "Business Unit"    = "Apificacion"
}

subnets = {
  jenkins-slave = {
    type                              = "private"
    availability_zone                 = "us-east-1a"
    cidr_block                        = "10.209.10.0/27"
    transit_gateway_direct_connection = false
  }
  eks-a = {
    type                              = "private"
    availability_zone                 = "us-east-1a"
    cidr_block                        = "10.209.10.128/25"
    transit_gateway_direct_connection = true
  }
  eks-b = {
    type                              = "private"
    availability_zone                 = "us-east-1b"
    cidr_block                        = "10.209.11.0/25"
    transit_gateway_direct_connection = true
  }
  eks-c = {
    type                              = "private"
    availability_zone                 = "us-east-1c"
    cidr_block                        = "10.209.11.128/25"
    transit_gateway_direct_connection = true
  }
  memcache = {
    type                              = "private"
    availability_zone                 = "us-east-1b"
    cidr_block                        = "10.209.10.64/26"
    transit_gateway_direct_connection = false
  }
  rds = {
    type                              = "private"
    availability_zone                 = "us-east-1b"
    cidr_block                        = "10.209.10.32/27"
    transit_gateway_direct_connection = false
  }
}

security_groups = {
  jenkins_slave_sg = {
    name        = "apificacion-jenkins-slave"
    description = "Security Group pra Jenkins Slave"

    ingress = [
      {
        from_port           = 50000
        to_port             = 50000
        protocol            = "tcp"
        cidr_blocks         = ["10.209.8.0/26"]
        self                = null
        security_group_name = null
        description         = "Permite la comunicacion JNLP desde el maestro de Jenkisn"
      },
      {
        from_port           = 22
        to_port             = 22
        protocol            = "tcp"
        cidr_blocks         = ["10.209.10.0/23"]
        self                = null
        security_group_name = null
        description         = "Permite la comunicacion SSH desde la VPC interna"
      },
      {
        from_port           = 22
        to_port             = 22
        protocol            = "tcp"
        cidr_blocks         = ["18.237.140.160/29"]
        self                = null
        security_group_name = null
        description         = "Permite la comunicacion SSH desde Instance Connect"
      }
    ]

    egress = [
      {
        from_port           = 0
        to_port             = 0
        protocol            = "-1"
        cidr_blocks         = ["0.0.0.0/0"]
        self                = null
        security_group_name = null
        description         = "Permite la salida a Internet"
      }
    ]
  }
  eks-sg = {
    name        = "apificion-eks-node-group"
    description = "Security Group para nodos de EKS"

    ingress = [
      {
        from_port           = 0
        to_port             = 65535
        protocol            = "tcp"
        cidr_blocks         = null
        self                = true
        security_group_name = null
        description         = "Permite la comunicacion TCP entre los nodos del EKS"
      },
      {
        from_port           = 0
        to_port             = 65535
        protocol            = "udp"
        cidr_blocks         = null
        self                = true
        security_group_name = null
        description         = "Permite la comunicacion UDP entre los nodos del EKS"
      },
      {
        from_port           = 80
        to_port             = 80
        protocol            = "tcp"
        cidr_blocks         = ["10.209.10.0/23"]
        self                = null
        security_group_name = null
        description         = "Permite la comunicacion HTTP desde el Load balancer"
      },
      {
        from_port           = 443
        to_port             = 443
        protocol            = "tcp"
        cidr_blocks         = ["0.0.0.0/0"]
        self                = null
        security_group_name = null
        description         = "Permite la comunicacion desde el Transit Gateway"
      },
    ]
    egress = [
      {
        from_port           = 0
        to_port             = 0
        protocol            = "-1"
        cidr_blocks         = ["0.0.0.0/0"]
        self                = null
        security_group_name = null
        description         = "Permite la salida a Internet"
      }
    ]
  }

  rds-sg = {
    name        = "apificacion-postgres-rds"
    description = "Security Group para RDS PostgreSQL"
    ingress = [
      {
        from_port           = 5432
        to_port             = 5432
        protocol            = "tcp"
        cidr_blocks         = ["10.209.10.0/23"]
        self                = null
        security_group_name = null
        description         = "Permite la comunicacion con los componentes de la VPC"
      }
    ]
    egress = []
  }

  memcache = {
    name        = "apificacion-memcache"
    description = "Security Group para Memcache"
    ingress = [
      {
        from_port           = 11211
        to_port             = 11211
        protocol            = "tcp"
        cidr_blocks         = ["10.209.10.0/23"]
        self                = null
        security_group_name = null
        description         = "Permite la comunicacion con los componentes de la VPC"
      }
    ]
    egress = []
  }
}

internet_gateway_cidr_blocks = {}

# Bancoppel Transit Gateway
transit_gateway_id = "tgw-012129fadcd7eeda8"

transit_gateway_cidr_blocks = {
  eks-a         = ["0.0.0.0/0"],
  eks-b         = ["0.0.0.0/0"],
  eks-c         = ["0.0.0.0/0"],
  jenkins-slave = ["0.0.0.0/0"]
}

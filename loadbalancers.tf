#Создание балансировщиков
resource "vkcs_lb_loadbalancer" "zone1-lb100" {
  name = "zone1-lb100"
  # availability_zone = var.zones["zone1"]
  availability_zone =  var.zones["zone1"]
  vip_subnet_id     = vkcs_networking_subnet.zone1-vnet100.id
  vip_address       = "172.16.100.2"
}

resource "vkcs_lb_loadbalancer" "zone2-lb200" {
  name              = "zone2-lb200"
  availability_zone = var.zones["zone2"]
  vip_subnet_id     = vkcs_networking_subnet.zone2-vnet200.id
  vip_address       = "172.16.200.2"
}

resource "vkcs_lb_loadbalancer" "zone3-lb000" {
  name              = "zone3-lb000"
  availability_zone = var.zones["zone3"]
  vip_subnet_id     = vkcs_networking_subnet.zone3-vnet000.id
  vip_address       = "172.16.0.2"
}

# Создание листенеров
resource "vkcs_lb_listener" "zone1-lb100-lst" {
  name            = "zone1-lb100-lst"
  loadbalancer_id = vkcs_lb_loadbalancer.zone1-lb100.id
  protocol        = "HTTP"
  protocol_port   = 80
}

resource "vkcs_lb_listener" "zone2-lb200-lst" {
  name            = "zone1-lb200-lst"
  loadbalancer_id = vkcs_lb_loadbalancer.zone2-lb200.id
  protocol        = "HTTP"
  protocol_port   = 80
}

resource "vkcs_lb_listener" "zone3-lb000-lst" {
  name            = "zone1-lb300-lst"
  loadbalancer_id = vkcs_lb_loadbalancer.zone3-lb000.id
  protocol        = "HTTP"
  protocol_port   = 80
}

# Создание пулов балансировки
resource "vkcs_lb_pool" "zone1_http" {
  name            = "zone1_http"
  listener_id = vkcs_lb_listener.zone1-lb100-lst.id
  protocol        = "HTTP"
  lb_method       = "ROUND_ROBIN"
}

resource "vkcs_lb_pool" "zone2_http" {
  name            = "zone2_http"
  listener_id = vkcs_lb_listener.zone2-lb200-lst.id
  protocol        = "HTTP"
  lb_method       = "ROUND_ROBIN"
}

resource "vkcs_lb_pool" "zone3_http" {
  name            = "zone3_http"
  listener_id = vkcs_lb_listener.zone3-lb000-lst.id
  protocol        = "HTTP"
  lb_method       = "ROUND_ROBIN"
}

#Добавление участников в балансировщики
resource "vkcs_lb_member" "zone1-front-http" {
  pool_id       = vkcs_lb_pool.zone1_http.id
  address       = "172.16.100.10"
  protocol_port = 80
}

resource "vkcs_lb_member" "zone2-front-http" {
  pool_id       = vkcs_lb_pool.zone2_http.id
  address       = "172.16.200.10"
  protocol_port = 80
}

resource "vkcs_lb_member" "zone3-front-http" {
  pool_id       = vkcs_lb_pool.zone3_http.id
  address       = "172.16.0.10"
  protocol_port = 80
}

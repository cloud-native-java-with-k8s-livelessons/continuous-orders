package com.example.hello;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ResponseBody;
import reactor.core.publisher.Flux;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;


@SpringBootApplication
public class OrdersApplication {

    public static void main(String[] args) {
        SpringApplication.run(OrdersApplication.class, args);
    }
}

@ResponseBody
@Controller
class OrderRestController {

    private final Map<Integer, Collection<Order>> db = new ConcurrentHashMap<>();

    OrderRestController() {
        for (var customerId = 1; customerId <= 8; customerId++) {
            var list = new ArrayList<Order>();
            for (var orderId = 1; orderId <= (Math.random() * 100); orderId++)
                list.add(new Order(customerId, orderId));
            this.db.put(customerId, list);
        }
    }

    @GetMapping("/orders/{cid}")
    Flux<Order> get(@PathVariable Integer cid) {
        return Flux.fromIterable(this.db.get(cid));
    }
}

record Order(Integer customerId, Integer id) {
}
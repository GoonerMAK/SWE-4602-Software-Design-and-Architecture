package com.example.inventoryservice.Controller;

import com.example.inventoryservice.Constants;
import com.example.inventoryservice.Entity.OrderStatus;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.stereotype.Component;

@Component
public class InventoryController {
    @RabbitListener(queues = Constants.QUEUE )
    public void consumeMessageFromQueue(OrderStatus orderStatus) {
        System.out.println("Message Received from queue: " + orderStatus );
    }
}
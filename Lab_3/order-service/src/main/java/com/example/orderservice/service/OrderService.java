package com.example.orderservice.service;

import com.example.orderservice.entity.Order;
import com.example.orderservice.repository.OrderRepository;
import com.example.orderservice.valueObject.Customer;
import com.example.orderservice.valueObject.Employee;
import com.example.orderservice.valueObject.Product;
import com.example.orderservice.valueObject.ResponseValueObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
public class OrderService {
    @Autowired
    private OrderRepository orderRepository;
    public Order saveOrder(Order order) {
        return orderRepository.save(order);
    }

    @Autowired
    private RestTemplate restTemplate;

    public ResponseValueObject findOrderById(String orderId) {
        ResponseValueObject ResponseValueObject = new ResponseValueObject();

        Order order = orderRepository.findOrderById(orderId);
        Product product = restTemplate.getForObject("http://PRODUCT-SERVICE/products/" + order.getProductId(), Product.class);
        Customer customer = restTemplate.getForObject("http://CUSTOMER-SERVICE/customers/" + order.getCustomerId(), Customer.class);
        Employee employee = restTemplate.getForObject("http://Employee-SERVICE/employees/" + order.getEmployeeId(), Employee.class);

        // The bellow line is also correct. static port is replaced by service
        // Customer customer = restTemplate.getForObject("http://localhost:9001/customers/" + order.getCustomerId(), Customer.class);

        ResponseValueObject.setCustomer(customer);
        ResponseValueObject.setProduct(product);
        ResponseValueObject.setEmployee(employee);
        ResponseValueObject.setOrder(order);

        return ResponseValueObject;
    }
}
import http from "k6/http";

export let options = {
    vus: 150,
    stages: [
        { duration: "1m", target: 200 },
        { duration: "1m", target: 200 },
        { duration: "1m", target: 0 },
    ]
};

export default function() {
    let response = http.get("http://ecs-9b8b-alb-example-806780129.eu-west-2.elb.amazonaws.com");
};

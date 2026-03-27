How does Route 53 know health?
For ELB/ALB:
It uses the load balancer's own health checks
Those checks depend on target group health (EC2 / services behind ALB)
So flow is like:

Route53 → ALB → Target Group → EC2 instances

If instances are unhealthy → ALB unhealthy → Route 53 avoids sending traffic


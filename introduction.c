// program to calculate the sum of (1,3,5,...,13,15)
int main()
{
    unsigned int sum;
    for int(i=1; i<=15;i+=2)
        sum+=i;
    while(1);
    return 0;
}

//program to send value )xAA to PORTD
#incluse <avr/io.h>
int main()
{
    DDRD = 0xFF;
    PORTD = 0xAA;
    while(1);
    return 0;
}
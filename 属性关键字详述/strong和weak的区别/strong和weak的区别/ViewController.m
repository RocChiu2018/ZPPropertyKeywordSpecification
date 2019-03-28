//
//  ViewController.m
//  strong和weak的区别
//
//  Created by apple on 16/7/12.
//  Copyright © 2016年 apple. All rights reserved.
//

/**
 指针的概念：以"NSString *str = @"abc";"代码为例，系统会先给一个字符串变量a（假定的名字）开辟一个内存空间，假定这个内存空间的地址为"ffc1"，然后系统会给字符串变量str开辟一个内存空间，假定这个内存空间的地址为"ffc2"。变量str所对应的内存空间内存储的是变量a所对应的内存空间的地址"ffc1"，这样的话就把变量str叫做指向变量a的指针，前述代码中的"*str"代表变量str是一个指针变量。根据指针变量str把字符串"abc"赋值到字符串变量a所对应的内存空间中。
 
 引用计数(retainCount)的概念：当对象属性被创建的时候，系统会在堆上随机分配一块内存空间用来表示这个对象属性，此时该对象属性的引用计数会由0变为1，并且被放入到系统的内存池中，中间对这个对象属性进行操作，它的引用计数可能会增加或减少，当引用计数减少到0的时候，系统的内存池就会检测到，然后系统就会释放这个对象属性对应的那片内存空间，然后把它清理出系统的内存池。
 
 属性关键字的剖析：
 在手动管理内存的时期(MRC)属性的关键字是"retain"、"assign"，属性默认的是assign。在自动管理内存的时期(ARC)属性的关键字由retain换为了"strong"，由assign换为了"weak"，对象属性默认的是strong，基本数据类型属性默认的还是assign。实际上strong和retain几乎没有什么区别，但是assign和weak还是有一点区别的，这在下面会进行介绍。
 1、atomic：原子属性。在多线程的情况下，当其中的某个线程getter这个属性的时候，为了避免其他的线程在同一时刻操作这个属性，就给这个属性在当前线程中加一个锁，当当前线程getter完这个属性后，才会解锁，然后同步其他线程给这个属性的新的setter值；在多线程的情况下，当其中的某个线程setter这个属性的时候，为了避免其他的线程在同一时刻操作这个属性，就给这个属性在当前线程中加一个锁，此时其他线程中只能getter到这个属性变化之前的值，当当前线程setter完这个属性后，才会解锁，这个时候其他线程getter到的值就是该属性变化之后的值了。上述的做法是线程安全的，但是需要消耗系统大量的资源；
 2、nonatomic：非原子属性。不会为线程加锁，非线程安全，但是消耗系统资源少，适合内存小的移动设备；
 备注：
 （1）所有属性都声明为nonatomic；
 （2）尽量避免多线程抢夺同一块资源；
 （3）尽量将加锁、资源抢夺的业务逻辑交给服务器端处理，减小客户端的压力。
 3、readwrite：属性可读可写，同时具有getter和setter方法，属性默认就是readwrite；
 4、readonly：属性只可读，不可写，只具备getter方法，不具备setter方法；
 5、strong：强引用，用强指针指着对象属性并持有该对象属性，该对象属性的引用计数会+1。对象属性有几个强指针指着它，则这个对象属性的引用计数就是几，当没有强指针指着它的时候则它的引用计数就变为了0，据上所述，系统就会释放这个对象属性对应的那片内存空间，然后把它清理出系统的内存池。所以一个对象属性如果有强指针指着它的话则不会被系统销毁，如果没有的话则立即会被系统销毁；
 strong关键字用来修饰在代码中直接撰写并且要在后面的代码中用"self."的方式来引用的UI控件。如果用weak关键字来修饰上述状况的UI控件的话则系统会报"Assigning retained object to weak property; object will be released after assignment"警告，意思就是说由弱指针指着的这个控件对象，待赋值之后会被释放，所以在此种情况下用weak关键字来修饰UI控件并不恰当，应该用strong关键字来进行修饰；
 除上述之外，strong关键字还可以修饰字典、可变字典、数组、可变数组等NSObject对象。
 6、weak：弱引用，用弱指针指着对象属性并不持有该对象属性，该对象属性的引用计数不变；
 weak关键字用来修饰在storyboard或者xib文件中用连线的方式引入到代码中的UI控件。在连线的过程中系统会默认用weak关键字来修饰这个控件，在后面的代码中也可以直接用"self."的方式来获取这个控件；
 UI控件可以使用strong关键字来修饰，也可以使用weak关键字来修饰，但是苹果官方推荐使用weak关键字来修饰。下面以从storyboard文件中引入的UIButton对象为例进行说明：ViewController对象里面有两个内存区域（指针变量），一个内存区域存储的是UIButton对象所对应的那块内存的地址（指针变量），即这块内存区域用弱指针指着代表UIButton对象的内存空间。另外一个内存区域存储的是ViewController对象里面一个用strong关键字来修饰的属性(UIView)所对应的那块内存空间的地址（指针变量），并且这个内存区域用一个强指针指着代表UIView对象的内存空间。UIView对象的内部有一个内存空间（指针变量），存储的是UIView对象里面一个用strong关键字来修饰的存储数组的属性(subviews)所对应的那块内存空间的地址，并且这个内存空间用一个强指针指着代表subviews对象属性的内存空间。subviews对象中的第0个元素用一个强指针指向之前的UIButton对象所对应的那块内存区域。到目前为止，一共有一个弱指针和一个强指针指向UIButton对象所对应的那块内存区域，所以设置UI控件属性的时候没必要使用strong关键字来进行修饰，使用weak关键字来修饰就足够了；
 weak关键字还可以用来修饰delegate属性。下面以在代码中直接撰写UITableView对象的方式为例进行说明：ViewController对象里面有一个内存空间，用来存储tableView对象所对应的那块内存的地址（指针变量），即这块内存区域用强指针指着代表tableView对象的内存空间。tableView对象的内部有一个内存空间（指针变量），存储的是tableView对象里面一个用weak关键字来修饰的属性(delegate)所对应的那块内存空间的地址，并且这个内存空间用一个弱指针指着代表delegate对象属性的内存空间。一般会把delegate对象设为这个ViewController对象，这样的话，这个指向这个delegate对象所对应的内存空间的弱指针就等同于指向这个ViewController对象自己，此时这个ViewController对象里有一个强指针指向别人，同时又有一个弱指针指向自己，当视图控制器将要销毁的时候，因为此ViewController对象没有被任何一个强指针指着，所以这个ViewController对象的引用计数为0，从而可以被销毁，当它被销毁的时候，它里面的指向tableView对象的指针变量也会被销毁，此时tableView对象所对应的那块内存区域不再被强指针指着了，引用计数为0了，会立即被系统销毁，此时它里面的指向delegate对象的弱指针也会被销毁，接着delegate对象所对应的那块内存区域会被销毁，然后指向ViewController对象的那个弱指针也就随着消失了。两个对象如果都用强指针相互指着的话（相互持有），因为被强指针指着的对象不能够被系统销毁，所以两个对象都不能够被销毁，所以两个对象相互指着的时候必须有一个是弱指针，有一个是强指针。
 7、assign：用一个强指针指着对象所对应的内存空间。用于修饰非对象类型，一般来修饰诸如int/float/BOOL/枚举/结构体等基本数据类型。对用这个关键字修饰的属性进行操作时，引用计数是一直不变的，一直为1，只有主动调用release方法时，属性才会被释放。
 备注：
 weak和assign的区别：用weak关键字修饰的对象属性在创建的时候系统会在堆上随机开辟一块内存a，代表这个对象，然后再开辟一块内存b，内存b里面存储的是内存a的地址，这样的话b就是一个指向a的弱指针变量了。当对象被销毁（内存a被销毁）后，那个弱指针变量会被自动置为nil，这样的话就不能通过弱指针再找到那个已经被销毁的内存a了，也就避免了出现已经不存在的对象调用方法的情况了，即避免了野指针的出现。如果用assign关键字修饰对象属性的话，b就是一个指向内存a的强指针，当对象被销毁（内存a被销毁）后，那个强指针变量不会自动置为nil，还保留着，这样就会造成野指针，使程序崩溃，所以不能使用assign关键字来修饰对象。如果使用assign关键字来修饰基本数据类型的话，基本数据类型所对应的内存空间会分配到栈上，栈的内存空间会由系统自己自动处理回收，不会造成野指针。
 8、copy：深赋值。比如，原来会有一个强指针变量a指着一个对象的内存空间aa，如果将这个对象赋值给经过copy关键字修饰过的属性，该属性并不会持有原来那个对象而是会新创建一个对象的内存空间bb，并且会有一个新的强指针指b着这个新的内存空间bb。使用copy关键字修饰的对象属性必须要实现<NSCopying>协议；
 copy一般用来修饰不可变字符串(NSString)、可变字符串(NSMutableString)、block函数等；
 copy可以用做关键字也可以用作方法，用作关键字的时候就是深拷贝，用作方法的时候对于不同的类可以是深拷贝方法也可以是浅拷贝方法这在下面的代码中会举例进行介绍。
 
 参考资料：
 1、https://www.jianshu.com/p/43f84673e8b1
 2、https://www.jianshu.com/p/9b05f9268494
 3、https://www.jianshu.com/p/de6328fda59c
 */
#import "ViewController.h"
#import "ZPPerson.h"
#import "ZPDog.h"
#import "ZPCat.h"

@interface ViewController ()
@property (nonatomic, strong) NSArray *array;

//自己在代码中撰写的UI控件用strong关键字来修饰。
@property (strong, nonatomic) UITableView *tableView;

//从storyboard文件中引出来的UI控件用weak关键字来修饰。
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation ViewController

#pragma mark ————— 生命周期 —————
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /**
     下面代码的意思是系统会在堆中产生两片内存空间，其中的一片用来存储等号右边的person对象，另外一片用来存储等号右边的代表person对象的那块内存空间的地址，即等号左边的指针变量"*person"，等号左边的内存空间用一个强指针指着等号右边的内存空间；
     在代码中，默认情况下所有的指针都是强指针，只有在前面明确用"__weak"关键字修饰的指针才是弱指针了；
     下面代码的作用域只限于这个大括号内，出了这个大括号，左边的指针变量就会被销毁，于是右边的内存空间就没有强指针指着了，就会被系统销毁掉。
     */
    ZPPerson *person = [[ZPPerson alloc] init];
    NSLog(@"person = %@", person);
    
//    [self test];
    
//    [self test1];
    
//    [self test2];
    
//    [self test3];
    
    [self test4];
}

-(void)test
{
    //在堆中，等号左边的内存空间（指针变量）用强指针指着等号右边的代表person对象的内存空间。
    ZPPerson *person = [[ZPPerson alloc] init];
    
    //在堆中，等号左边的内存空间（指针变量）用强指针指着等号右边的代表dog对象的内存空间。
    ZPDog *dog = [[ZPDog alloc] init];
    
    //因为ZPPerson类里面的dog属性用strong关键字来修饰，所以person对象里面的内存空间(指针变量)用强指针指向dog对象所对应的那片内存空间，所以说只要person对象在，里面的dog属性就在，这个属性指向的dog对象就在，这就是对象属性用strong关键字来修饰的原因。
    person.dog = dog;
}

#pragma mark ————— 深拷贝 —————
- (void)test1
{
    /**
     当一个可变对象(NSMutableString,NSMutableArray,NSMutableDictionary)调用copy方法的时候，系统会把原来的可变对象复制一个不可变对象(NSString,NSArray,NSDictionary)的副本出来，并且这个副本由一个新的指针指着。当修改原可变对象的时候不会影响复制出来的副本文件，同理，当修改复制出来的副本文件（当然也不能够修改）的时候也不会影响原对象，这种拷贝方式叫做深拷贝，也叫做内容拷贝。
     */
    
    //这里以可变字符串对象为例
    NSMutableString *mulStr = [NSMutableString string];
    [mulStr appendString:@"1"];
    [mulStr appendString:@"2"];
    NSLog(@"%@, %p",mulStr, mulStr);
    
    NSString *str = [mulStr copy];
    NSLog(@"%@, %p", str, str);
    
    /**
     当一个可变对象调用mutableCopy方法的时候，也是深拷贝，拷贝出来的副本也是一个可变对象。
     */
    
    //这里以可变字符串对象为例
    NSMutableString *mulStr1 = [mulStr mutableCopy];
    [mulStr1 appendString:@"3"];
    NSLog(@"%@, %p", mulStr1, mulStr1);
    
    /**
     总结：对于可变对象而言，不管调用的是copy方法还是mutableCopy方法，都是深拷贝，只不过调用copy方法以后复制出来的对象是不可变对象，调用mutableCopy方法以后复制出来的对象是可变对象。
     */
}

#pragma mark ————— 浅拷贝 —————
- (void)test2
{
    /**
     当一个不可变对象(NSString,NSArray,NSDictionary)调用copy方法的时候，不会复制一个新的副本，只会生成一个新的指针，并且原指针和新指针都指向那个不可变对象。这种拷贝方式叫做浅拷贝，也叫作指针拷贝。
     */

    //这里以不可变字符串为例
    NSString *str = @"12";
    
    NSString *str1 = [str copy];
    NSLog(@"%@, %@, %p, %p", str, str1, str, str1);
    
    /**
     当一个不可变对象调用mutableCopy方法的时候，是深拷贝，会复制出来一个可变对象。
     */
    
    //这里以不可变字符串为例
    NSMutableString *str2 = [str mutableCopy];
    [str stringByAppendingString:@"3"];
    NSLog(@"%@, %p", str2, str2);
    
    /**
     总结：当一个不可变对象调用copy方法的时候，是浅拷贝，前后两个指针都指向那个不可变对象。当一个不可变对象调用mutableCopy方法的时候，是深拷贝，会复制出来一个可变对象。
     */
}

- (void)test3
{
//    ZPDog *dog = [[ZPDog alloc] init];
    
    /**
     下面代码中不管调用的是"copy"还是"mutableCopy"方法，当程序运行到这句代码的时候都会崩溃，原因是系统找不到ZPDog类的"copyWithZone:"或者"mutableCopyWithZone:"方法；
     当程序调用对象的"copy"或者"mutableCopy"方法来复制自身时，系统底层会分别调用相应的"copyWithZone:"或者"mutableCopyWithZone:"方法。"copy"方法实际上就是"copyWithZone:"方法的返回值，"mutableCopy"方法实际上就是"mutableCopyWithZone:"方法的返回值；
     如果想要解决上述的问题就要先让相应的类实现<NSCopying>或者<NSMutableCopying>协议，然后在相应的类里面实现"copyWithZone:"或者"mutableCopyWithZone:"方法，例如ZPCat类。
     */
//    ZPDog *dog1 = [dog copy];
    
    ZPCat *cat = [[ZPCat alloc] init];
    cat.age = 10;
    
    //当调用copy方法的时候，系统会自动调用"copyWithZone:"方法，从而生成一个新的副本文件（深拷贝）。
    ZPCat *cat1 = [cat copy];
    cat1.age = 12;
    
    ZPCat *cat2 = [cat copy];
    cat2.age = 13;
    
    ZPCat *cat3 = [cat copy];
    cat3.age = 15;
    
    NSLog(@"%p, %p, %p, %p", cat, cat1, cat2, cat3);
    NSLog(@"%d, %d, %d, %d", cat.age, cat1.age, cat2.age, cat3.age);
}

- (void)test4
{
    NSMutableString *mulStr = [NSMutableString stringWithFormat:@"jack"];
    
    ZPCat *cat = [[ZPCat alloc] init];
    cat.name = mulStr;
    
    [mulStr appendString:@" rose"];
    
    NSLog(@"%@, %@", mulStr, cat.name);
}

@end

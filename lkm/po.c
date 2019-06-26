#include <linux/module.h>	/* Needed by all modules */
#include <linux/kernel.h>	/* Needed for KERN_INFO */
#include <linux/fs.h>		  /* Needed for KERN_INFO */
#include <asm/io.h>       /* Needed for inl and outl */

#define PM1a_CNT_BLK 0x1804

unsigned char bytes[10];

int __init lkm_init(void)
{
  unsigned int pm1a;

	printk(KERN_INFO "I'm going to power the computer off");
	
  
  pm1a = inl(PM1a_CNT_BLK);
  pm1a = ( pm1a & 0xffffc003 ) | ( 7 << 10 ) | ( 1 << 13 );
  outl(pm1a, PM1a_CNT_BLK);

  printk(KERN_WARNING "Powering off failed");

	return 0;
}


static void __exit lkm_exit(void)
{
}

module_init(lkm_init);
module_exit(lkm_exit);

MODULE_LICENSE("Dual BSD/GPL");
MODULE_AUTHOR("M.Bloom");
MODULE_DESCRIPTION("Attempt to power down the computer");

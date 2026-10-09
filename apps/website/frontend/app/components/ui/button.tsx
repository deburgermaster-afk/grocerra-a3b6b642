import * as React from "react";
import { cva, type VariantProps } from "class-variance-authority";
import { cn } from "../../lib/utils";

const buttonVariants = cva("inline-flex items-center justify-center", {
  variants: {
    variant: {
      default: "rounded-md bg-primary px-4 py-2 text-primary-foreground",
      destructive: "rounded-md bg-destructive px-4 py-2 text-white",
      outline: "rounded-md border border-input bg-background px-4 py-2",
      secondary: "rounded-md bg-secondary px-4 py-2 text-secondary-foreground",
      ghost: "rounded-md px-4 py-2 hover:bg-accent hover:text-accent-foreground",
      link: "text-primary underline-offset-4 hover:underline",
      unstyled: "",
    },
    size: {
      default: "h-9",
      sm: "h-8 px-3",
      lg: "h-10 px-6",
      icon: "size-9",
    },
  },
  defaultVariants: {
    variant: "default",
    size: "default",
  },
});

type ButtonProps = React.ComponentProps<"button"> & VariantProps<typeof buttonVariants>;

function Button({ className, variant, size, ...props }: ButtonProps) {
  return <button className={cn(buttonVariants({ variant, size }), className)} {...props} />;
}

export { Button, buttonVariants };
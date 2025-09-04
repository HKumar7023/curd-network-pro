import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class AnimatedAddToCartButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isInCart;
  final IconData icon;

  const AnimatedAddToCartButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.isInCart = false,
    this.icon = Icons.add_shopping_cart,
  }) : super(key: key);

  @override
  State<AnimatedAddToCartButton> createState() => _AnimatedAddToCartButtonState();
}

class _AnimatedAddToCartButtonState extends State<AnimatedAddToCartButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _slideController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _scaleController = AnimationController(
      duration: AppConstants.shortAnimationDuration,
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: AppConstants.mediumAnimationDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -0.1),
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _handlePress() async {
    if (widget.onPressed != null) {
      // Scale down animation
      await _scaleController.forward();
      await _scaleController.reverse();
      
      // Execute the callback
      widget.onPressed!();
      
      // Slide up animation
      await _slideController.forward();
      await _slideController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_scaleController, _slideController]),
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: ElevatedButton.icon(
              onPressed: widget.isInCart ? null : _handlePress,
              icon: AnimatedSwitcher(
                duration: AppConstants.shortAnimationDuration,
                child: Icon(
                  widget.isInCart ? Icons.check : widget.icon,
                  key: ValueKey(widget.isInCart),
                ),
              ),
              label: AnimatedSwitcher(
                duration: AppConstants.shortAnimationDuration,
                child: Text(
                  widget.text,
                  key: ValueKey(widget.text),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class AnimatedCartIcon extends StatefulWidget {
  final int itemCount;
  final VoidCallback? onTap;

  const AnimatedCartIcon({
    Key? key,
    required this.itemCount,
    this.onTap,
  }) : super(key: key);

  @override
  State<AnimatedCartIcon> createState() => _AnimatedCartIconState();
}

class _AnimatedCartIconState extends State<AnimatedCartIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;
  int _previousItemCount = 0;

  @override
  void initState() {
    super.initState();
    _previousItemCount = widget.itemCount;
    
    _bounceController = AnimationController(
      duration: AppConstants.mediumAnimationDuration,
      vsync: this,
    );

    _bounceAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void didUpdateWidget(AnimatedCartIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.itemCount > _previousItemCount) {
      _bounceController.forward().then((_) {
        _bounceController.reverse();
      });
    }
    _previousItemCount = widget.itemCount;
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _bounceAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _bounceAnimation.value,
            child: Stack(
              children: [
                const Icon(Icons.shopping_cart),
                if (widget.itemCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: AnimatedContainer(
                      duration: AppConstants.shortAnimationDuration,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.error,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${widget.itemCount}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onError,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class SlidePageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final Offset beginOffset;
  final Offset endOffset;

  SlidePageRoute({
    required this.child,
    this.beginOffset = const Offset(1.0, 0.0),
    this.endOffset = Offset.zero,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: AppConstants.mediumAnimationDuration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: beginOffset,
                end: endOffset,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              )),
              child: child,
            );
          },
        );
}

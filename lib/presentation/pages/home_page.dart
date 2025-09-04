import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/constants/app_constants.dart';
import '../../core/themes/app_theme.dart';
import '../providers/product_providers.dart';
import '../widgets/professional_product_card.dart';
import '../widgets/loading_shimmer.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(filteredProductsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    
    // Debug prints removed for production
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          'app_name'.tr(),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_outlined,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          
          // Clean Search Bar
          Container(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            color: Theme.of(context).colorScheme.surface,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                hintStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                        ),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(searchQueryProvider.notifier).state = '';
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppTheme.primaryColor, width: 1.5),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.background,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (value) {
                ref.read(searchQueryProvider.notifier).state = value;
              },
            ),
          ),
          
          // Categories Filter
          categoriesAsync.when(
            data: (categories) => Container(
              height: 50,
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.defaultPadding,
                vertical: 8,
              ),
              color: Theme.of(context).colorScheme.surface,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length + 1, // +1 for "All" option
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _buildCategoryChip(
                        context,
                        'All',
                        selectedCategory == null,
                        () => ref.read(selectedCategoryProvider.notifier).state = null,
                      ),
                    );
                  }
                  
                  final category = categories[index - 1];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _buildCategoryChip(
                      context,
                      category[0].toUpperCase() + category.substring(1),
                      selectedCategory == category,
                      () => ref.read(selectedCategoryProvider.notifier).state =
                          selectedCategory == category ? null : category,
                    ),
                  );
                },
              ),
            ),
            loading: () => const SizedBox(height: 50),
            error: (_, __) => const SizedBox(height: 50),
          ),
          
          // Products Grid
          Expanded(
            child: productsAsync.when(
              data: (products) {
                if (products.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          size: 64,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'no_products'.tr(),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  );
                }



                return GridView.builder(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _getCrossAxisCount(context),
                    childAspectRatio: 0.4,
                    crossAxisSpacing: AppConstants.smallPadding,
                    mainAxisSpacing: AppConstants.smallPadding,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return ProfessionalProductCard(product: products[index]);
                  },
                );
              },
              loading: () => LoadingShimmer(
                itemCount: 6,
                // crossAxisCount: _getCrossAxisCount(context),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'failed_to_load_products'.tr(),
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.toString(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        ref.invalidate(productListProvider);
                      },
                      icon: const Icon(Icons.refresh),
                      label: Text('retry'.tr()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        ),
      );
  }

  Widget _buildCategoryChip(
    BuildContext context,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: AppTheme.primaryColor.withOpacity(0.15),
      backgroundColor: Theme.of(context).colorScheme.background,
      checkmarkColor: AppTheme.primaryColor,
      labelStyle: TextStyle(
        color: isSelected
            ? AppTheme.primaryColor
            : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        fontSize: 13,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected
              ? AppTheme.primaryColor
              : Theme.of(context).colorScheme.outline.withOpacity(0.3),
          width: 1,
        ),
      ),
      elevation: 0,
      pressElevation: 1,
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth > AppConstants.tabletBreakpoint) {
      return AppConstants.desktopGridCrossAxisCount;
    } else if (screenWidth > AppConstants.mobileBreakpoint) {
      return AppConstants.tabletGridCrossAxisCount;
    } else {
      return AppConstants.mobileGridCrossAxisCount;
    }
  }
}

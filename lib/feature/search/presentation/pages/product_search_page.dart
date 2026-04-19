import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_user_v3/config/theme/spacing.dart';
import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/widgets/custom_app_bar.dart';
import 'package:zadana_user_v3/feature/search/domain/entities/product_search_params.dart';
import 'package:zadana_user_v3/feature/search/presentation/manager/product_search_cubit.dart';
import 'package:zadana_user_v3/feature/search/presentation/manager/product_search_event.dart';
import 'package:zadana_user_v3/feature/search/presentation/widgets/product_search_input.dart';
import 'package:zadana_user_v3/feature/search/presentation/widgets/product_search_results_view.dart';

class ProductSearchPage extends StatefulWidget {
  const ProductSearchPage({super.key, required this.params});

  final ProductSearchParams params;

  @override
  State<ProductSearchPage> createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends State<ProductSearchPage> {
  static const double _loadMoreThreshold = 320;

  late final ProductSearchViewModel _viewModel;
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<ProductSearchViewModel>(param1: widget.params);
    _controller = TextEditingController(text: widget.params.initialQuery);
    _focusNode = FocusNode();
    _scrollController = ScrollController()..addListener(_handleScroll);
    _requestAutofocus();
  }

  void _requestAutofocus() {
    if (!widget.params.autofocus) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  Future<void> _handleScroll() async {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.extentAfter > _loadMoreThreshold) return;
    _viewModel.doIntent(const ProductSearchLoadMoreEvent());
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    _viewModel.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _viewModel,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Scaffold(
          appBar: CustomAppBar(title: widget.params.title),
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Spacing.md,
                    Spacing.sm,
                    Spacing.md,
                    Spacing.sm,
                  ),
                  child: ProductSearchInput(
                    controller: _controller,
                    focusNode: _focusNode,
                    hintText: widget.params.hintText,
                    onChanged: (value) => _viewModel.doIntent(
                      ProductSearchQueryChangedEvent(value),
                    ),
                  ),
                ),
                Expanded(
                  child: ProductSearchResultsView(
                    scrollController: _scrollController,
                    onRetry: () =>
                        _viewModel.doIntent(const ProductSearchRetryEvent()),
                    onRefresh: () async =>
                        _viewModel.doIntent(const ProductSearchRefreshEvent()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

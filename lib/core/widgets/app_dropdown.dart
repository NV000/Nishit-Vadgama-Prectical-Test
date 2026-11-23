import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:nishit_vadgama/core/constants/app_colors.dart';
import 'package:nishit_vadgama/core/constants/app_sizes.dart';
import 'package:nishit_vadgama/core/extensions/context_extension.dart';
import 'package:nishit_vadgama/core/theme/app_text_style.dart';

/// Production-ready generic dropdown widget supporting real-time search filtering,
/// animated popover overlay, an inline right-side "Add" action button matching the
/// app design system, and automated smooth viewport scrolling when typing/focusing.
class AppDropdown<T> extends StatefulWidget {
  final T? value;
  final List<T> items;
  final String Function(T item)? itemLabel;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final ValueChanged<T?>? onChanged;
  final String? addNewLabel;
  final VoidCallback? onAddNew;
  final void Function(String currentQuery)? onAddNewWithQuery;
  final bool? showAddButton;
  final bool showAddInOverlay;
  final Widget? addButtonIcon;
  final String? addButtonTooltip;
  final bool isSearchable;
  final bool enabled;
  final double? radius;
  final bool autoScrollOnFocus;
  final String? Function(T?)? validator;
  final Widget? prefixIcon;
  final FocusNode? focusNode;
  final TextEditingController? textController;
  final bool Function(T item, String query)? searchFilter;
  final double maxOverlayHeight;

  const AppDropdown({
    super.key,
    required this.items,
    this.value,
    this.itemLabel,
    this.labelText,
    this.hintText,
    this.helperText,
    this.onChanged,
    this.addNewLabel,
    this.onAddNew,
    this.onAddNewWithQuery,
    this.showAddButton,
    this.showAddInOverlay = false,
    this.addButtonIcon,
    this.addButtonTooltip,
    this.isSearchable = true,
    this.enabled = true,
    this.radius,
    this.autoScrollOnFocus = true,
    this.validator,
    this.prefixIcon,
    this.focusNode,
    this.textController,
    this.searchFilter,
    this.maxOverlayHeight = 240.0,
  });

  @override
  State<AppDropdown<T>> createState() => _AppDropdownState<T>();
}

class _AppDropdownState<T> extends State<AppDropdown<T>> {
  static const double _fieldHeight = 54.0;

  final LayerLink _layerLink = LayerLink();
  final GlobalKey _fieldKey = GlobalKey();

  late final FocusNode _focusNode;
  late final TextEditingController _textController;
  final ValueNotifier<bool> _isOpenNotifier = ValueNotifier<bool>(false);

  OverlayEntry? _overlayEntry;
  List<T> _filteredItems = [];
  T? _selectedItem;

  bool get _shouldShowAddButton =>
      widget.showAddButton ??
      (widget.onAddNew != null || widget.onAddNewWithQuery != null);

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _textController = widget.textController ?? TextEditingController();
    _selectedItem = widget.value;
    _filteredItems = List<T>.from(widget.items);

    final selected = _selectedItem;
    if (selected != null) {
      _textController.text = _getItemString(selected);
    }

    _focusNode.addListener(_handleFocusChanged);
  }

  @override
  void didUpdateWidget(covariant AppDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _selectedItem = widget.value;
      final selected = _selectedItem;
      _textController.text = selected != null ? _getItemString(selected) : '';
    }
    if (widget.items != oldWidget.items) {
      _filterItems(_textController.text);
    }
  }

  @override
  void dispose() {
    _removeOverlay(unfocus: false);
    _focusNode.removeListener(_handleFocusChanged);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    if (widget.textController == null) {
      _textController.dispose();
    }
    _isOpenNotifier.dispose();
    super.dispose();
  }

  String _getItemString(T item) =>
      widget.itemLabel != null ? widget.itemLabel!(item) : item.toString();

  void _handleFocusChanged() {
    if (_focusNode.hasFocus) {
      _openDropdown();
      _scrollToField();
    } else {
      _removeOverlay(unfocus: false);
      final selected = _selectedItem;
      if (selected != null) {
        _textController.text = _getItemString(selected);
      } else {
        _textController.clear();
      }
    }
  }

  void _handleAddNew() {
    if (!widget.enabled) return;
    final selected = _selectedItem;
    final currentText = _textController.text.trim();
    final query = selected != null && currentText == _getItemString(selected)
        ? ''
        : currentText;

    _removeOverlay(unfocus: true);
    if (widget.onAddNewWithQuery != null) {
      widget.onAddNewWithQuery!(query);
    } else {
      widget.onAddNew?.call();
    }
  }

  void _filterItems(String query) {
    final cleanQuery = query.trim().toLowerCase();
    setState(() {
      if (cleanQuery.isEmpty) {
        _filteredItems = List<T>.from(widget.items);
      } else {
        _filteredItems = widget.items.where((item) {
          if (widget.searchFilter != null) {
            return widget.searchFilter!(item, cleanQuery);
          }
          return _getItemString(item).toLowerCase().contains(cleanQuery);
        }).toList();
      }
    });
    _overlayEntry?.markNeedsBuild();
  }

  void _scrollToField() {
    if (!widget.autoScrollOnFocus) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final targetContext = _fieldKey.currentContext ?? context;
      Scrollable.ensureVisible(
        targetContext,
        alignment: 0.08,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  void _toggleDropdown() {
    if (!widget.enabled) return;
    if (_isOpenNotifier.value) {
      _removeOverlay(unfocus: true);
    } else {
      _focusNode.requestFocus();
      _openDropdown();
      _scrollToField();
    }
  }

  void _openDropdown() {
    if (_overlayEntry != null || !mounted) return;

    _filteredItems = List<T>.from(widget.items);
    _textController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _textController.text.length,
    );

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _isOpenNotifier.value = true;
  }

  void _removeOverlay({bool unfocus = true}) {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _isOpenNotifier.value = false;
    }
    if (unfocus && _focusNode.hasFocus) {
      _focusNode.unfocus();
    }
  }

  void _selectItem(T item) {
    setState(() {
      _selectedItem = item;
      _textController.text = _getItemString(item);
    });
    _removeOverlay(unfocus: true);
    widget.onChanged?.call(item);
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox =
        _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    final size = renderBox?.size ?? Size.zero;

    return OverlayEntry(
      builder: (_) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => _removeOverlay(unfocus: true),
            ),
          ),
          CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, size.height + 6),
            child: Material(
              type: MaterialType.transparency,
              child: _buildOverlayCard(size.width),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlayCard(double width) {
    final showOverlayAction =
        widget.showAddInOverlay && widget.addNewLabel != null;

    return SizedBox(
      width: width,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: widget.maxOverlayHeight + (showOverlayAction ? 70.0 : 0.0),
        ),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: context.colorScheme.outlineVariant,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showOverlayAction) _buildOverlayAddTile(),
              if (_filteredItems.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                      'No options found',
                      style: AppTextStyle.bodySmall.copyWith(
                        color: context.colorScheme.outline,
                      ),
                    ),
                  ),
                )
              else
                Flexible(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 6,
                    ),
                    shrinkWrap: true,
                    itemCount: _filteredItems.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 2),
                    itemBuilder: (_, index) =>
                        _buildOverlayItem(_filteredItems[index]),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverlayAddTile() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      child: InkWell(
        onTap: _handleAddNew,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFEEF3F8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.addNewLabel!,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: context.colorScheme.onSurface,
                ),
              ),
              Icon(Icons.add, size: 20, color: context.colorScheme.onSurface),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverlayItem(T item) {
    final isSelected = _selectedItem == item;
    final label = _getItemString(item);

    return InkWell(
      onTap: () => _selectItem(item),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isSelected
              ? context.colorScheme.primary.withValues(alpha: 0.08)
              : Colors.transparent,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected
                ? AppColors.primary
                : context.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context, BorderRadius effectiveRadius) {
    return Tooltip(
      message: widget.addButtonTooltip ?? widget.addNewLabel ?? 'Add New',
      child: Material(
        color: context.colorScheme.surface,
        borderRadius: effectiveRadius,
        child: InkWell(
          onTap: widget.enabled ? _handleAddNew : null,
          borderRadius: effectiveRadius,
          child: Container(
            width: _fieldHeight,
            height: _fieldHeight,
            decoration: BoxDecoration(
              borderRadius: effectiveRadius,
              border: Border.all(
                color: context.colorScheme.onSecondaryContainer.withValues(
                  alpha: 0.2,
                ),
              ),
            ),
            alignment: Alignment.center,
            child:
                widget.addButtonIcon ??
                Icon(
                  Iconsax.add_circle_copy,
                  size: 26,
                  color: widget.enabled
                      ? AppColors.primary
                      : context.colorScheme.outline,
                ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(
    BuildContext context,
    BorderRadius effectiveRadius,
    bool isOpen,
  ) {
    final defaultBorder = OutlineInputBorder(
      borderRadius: effectiveRadius,
      borderSide: BorderSide(
        color: context.colorScheme.onSecondaryContainer.withValues(alpha: 0.2),
      ),
    );

    return InputDecoration(
      hintText: widget.hintText,
      constraints: const BoxConstraints(minHeight: _fieldHeight),
      prefixIcon: widget.prefixIcon != null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [widget.prefixIcon!],
            )
          : null,
      filled: true,
      fillColor: context.colorScheme.surface,
      hintStyle: AppTextStyle.button.copyWith(
        color: context.colorScheme.outline,
        fontWeight: FontWeight.w600,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
      border: defaultBorder,
      enabledBorder: defaultBorder,
      focusedBorder: OutlineInputBorder(
        borderRadius: effectiveRadius,
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: effectiveRadius,
        borderSide: const BorderSide(color: AppColors.error, width: 1.2),
      ),
      suffixIcon: IconButton(
        onPressed: _toggleDropdown,
        icon: AnimatedRotation(
          turns: isOpen ? 0.5 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: Icon(
            Icons.arrow_drop_down,
            size: 30,
            color: context.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = widget.radius != null
        ? BorderRadius.circular(widget.radius!)
        : AppSizes.radiusMd;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: context.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSizes.s8),
        ],
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CompositedTransformTarget(
                link: _layerLink,
                child: ValueListenableBuilder<bool>(
                  valueListenable: _isOpenNotifier,
                  key: _fieldKey,
                  builder: (context, isOpen, _) {
                    return TextFormField(
                      controller: _textController,
                      focusNode: _focusNode,
                      readOnly: !widget.isSearchable,
                      enabled: widget.enabled,
                      validator: widget.validator != null
                          ? (_) => widget.validator!(_selectedItem)
                          : null,
                      onTap: () {
                        if (!_isOpenNotifier.value) {
                          _openDropdown();
                          _scrollToField();
                        }
                      },
                      onChanged: (query) {
                        _filterItems(query);
                        _scrollToField();
                      },
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: context.colorScheme.onSurface,
                      ),
                      decoration: _buildInputDecoration(
                        context,
                        effectiveRadius,
                        isOpen,
                      ),
                    );
                  },
                ),
              ),
            ),
            if (_shouldShowAddButton) ...[
              const SizedBox(width: AppSizes.s10),
              _buildAddButton(context, effectiveRadius),
            ],
          ],
        ),
        if (widget.helperText != null) ...[
          const SizedBox(height: 6),
          Text(
            widget.helperText!,
            style: AppTextStyle.bodySmall.copyWith(
              color: context.colorScheme.onSecondaryContainer,
            ),
          ),
        ],
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const NJMakerApp());
}

// ============================================================================
// PALETA OFICIAL NJ MAKER (3D PRINT & DESIGN)
// ============================================================================
class NJColors {
  static const Color cyanElectric = Color(0xFF00B4D8);
  static const Color blueCobalt = Color(0xFF3B82F6);
  static const Color indigoDeep = Color(0xFF4F46E5);
  static const Color purpleMaker = Color(0xFF9333EA);
  static const Color navyDark = Color(0xFF0F172A);
  static const Color slateBg = Color(0xFFF8FAFC);

  static const LinearGradient brandGradient = LinearGradient(
    colors: [cyanElectric, indigoDeep, purpleMaker],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

// ============================================================================
// MODELOS DE DATOS
// ============================================================================
class FilamentColor {
  final String id;
  final String name;
  final Color primaryColor;
  final Color secondaryColor;
  final bool isGradient;

  const FilamentColor({
    required this.id,
    required this.name,
    required this.primaryColor,
    required this.secondaryColor,
    this.isGradient = false,
  });
}

class PrintMaterial {
  final String id;
  final String name;
  final String subtitle;
  final double multiplier;
  final double pricePerGram;

  const PrintMaterial({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.multiplier,
    required this.pricePerGram,
  });
}

class Product3D {
  final String id;
  String name;
  String category;
  double basePrice;
  int grams;
  double hours;
  String dimensions;
  String description;
  String shapeType;
  String badge;

  Product3D({
    required this.id,
    required this.name,
    required this.category,
    required this.basePrice,
    required this.grams,
    required this.hours,
    required this.dimensions,
    required this.description,
    required this.shapeType,
    required this.badge,
  });
}

class CartItem {
  final String id;
  final String name;
  final String materialName;
  final String colorName;
  final Color previewColor;
  final double unitPrice;
  final String specs;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.materialName,
    required this.colorName,
    required this.previewColor,
    required this.unitPrice,
    required this.specs,
    this.quantity = 1,
  });
}

// ============================================================================
// DATOS INICIALES
// ============================================================================
const List<FilamentColor> kFilamentColors = [
  FilamentColor(
    id: 'nj_grad',
    name: 'Gradiente NJ (Cian-Violeta)',
    primaryColor: Color(0xFF00B4D8),
    secondaryColor: Color(0xFF9333EA),
    isGradient: true,
  ),
  FilamentColor(
    id: 'cyan_neon',
    name: 'Cian Eléctrico',
    primaryColor: Color(0xFF00B4D8),
    secondaryColor: Color(0xFF0284C7),
  ),
  FilamentColor(
    id: 'purple_silk',
    name: 'Violeta Seda 3D',
    primaryColor: Color(0xFF9333EA),
    secondaryColor: Color(0xFF6B21A8),
  ),
  FilamentColor(
    id: 'cobalt_pro',
    name: 'Azul Cobalto',
    primaryColor: Color(0xFF3B82F6),
    secondaryColor: Color(0xFF1D4ED8),
  ),
  FilamentColor(
    id: 'carbon_black',
    name: 'Negro Fibra Carbono',
    primaryColor: Color(0xFF1E293B),
    secondaryColor: Color(0xFF0F172A),
  ),
  FilamentColor(
    id: 'marble_white',
    name: 'Blanco Mármol',
    primaryColor: Color(0xFFE2E8F0),
    secondaryColor: Color(0xFF94A3B8),
  ),
];

const List<PrintMaterial> kPrintMaterials = [
  PrintMaterial(
    id: 'pla_plus',
    name: 'PLA+ Pro',
    subtitle: 'Acabado fino y colores vibrantes',
    multiplier: 1.0,
    pricePerGram: 0.08,
  ),
  PrintMaterial(
    id: 'petg',
    name: 'PETG Industrial',
    subtitle: 'Alta resistencia mecánica y térmica',
    multiplier: 1.25,
    pricePerGram: 0.10,
  ),
  PrintMaterial(
    id: 'abs_cf',
    name: 'ABS / Fibra Carbono',
    subtitle: 'Grado automotriz y estructural',
    multiplier: 1.45,
    pricePerGram: 0.13,
  ),
  PrintMaterial(
    id: 'resin_8k',
    name: 'Resina 8K Ultra',
    subtitle: 'Detalle microscópico sin líneas',
    multiplier: 1.75,
    pricePerGram: 0.16,
  ),
];

// ============================================================================
// APP PRINCIPAL
// ============================================================================
class NJMakerApp extends StatefulWidget {
  const NJMakerApp({super.key});

  @override
  State<NJMakerApp> createState() => _NJMakerAppState();
}

class _NJMakerAppState extends State<NJMakerApp> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NJ MAKER - 3D Print & Design',
      debugShowCheckedModeBanner: false,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: NJColors.slateBg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: NJColors.cyanElectric,
          primary: NJColors.indigoDeep,
          secondary: NJColors.purpleMaker,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B1120),
        colorScheme: ColorScheme.fromSeed(
          seedColor: NJColors.cyanElectric,
          primary: NJColors.cyanElectric,
          secondary: NJColors.purpleMaker,
          brightness: Brightness.dark,
        ),
      ),
      home: MainShell(
        isDarkMode: _isDarkMode,
        onToggleTheme: () => setState(() => _isDarkMode = !_isDarkMode),
      ),
    );
  }
}

// ============================================================================
// SHELL PRINCIPAL CON BARRA DE NAVEGACIÓN INFERIOR (4 PESTAÑAS)
// ============================================================================
class MainShell extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const MainShell({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;
  String _selectedCategory = 'Todos';

  final List<Product3D> _products = [
    Product3D(
      id: 'nj-01',
      name: 'Soporte Gamer Articulado DualSense / Xbox',
      category: 'Gaming & Setup',
      basePrice: 16.50,
      grams: 145,
      hours: 4.5,
      dimensions: '140 x 115 x 185 mm',
      description: 'Base ergonómica impresa con textura de capas visibles o acabado seda degradado NJ.',
      shapeType: 'stand',
      badge: 'Más Vendido',
    ),
    Product3D(
      id: 'nj-02',
      name: 'Lámpara Arquitectónica Voronói LED',
      category: 'Decoración',
      basePrice: 24.00,
      grams: 210,
      hours: 6.8,
      dimensions: '160 x 160 x 240 mm',
      description: 'Difusor orgánico traslúcido diseñado por computadora con base para bombillo LED.',
      shapeType: 'lamp',
      badge: 'Diseño Exclusivo',
    ),
    Product3D(
      id: 'nj-03',
      name: 'Engranaje Planetario / Repuesto Mecánico CAD',
      category: 'Industrial & CAD',
      basePrice: 19.00,
      grams: 120,
      hours: 3.8,
      dimensions: '95 x 95 x 42 mm',
      description: 'Pieza funcional de tolerancia 0.12mm impresa con relleno reforzado gyroid.',
      shapeType: 'gear',
      badge: 'Alta Precisión',
    ),
    Product3D(
      id: 'nj-04',
      name: 'Letrero Corporativo 3D con Relieve Luminoso',
      category: 'Corporativo',
      basePrice: 35.00,
      grams: 340,
      hours: 9.0,
      dimensions: '350 x 180 x 35 mm',
      description: 'Logotipo tridimensional personalizado para negocios, recepciones y estudios.',
      shapeType: 'logo',
      badge: 'Personalizable',
    ),
    Product3D(
      id: 'nj-05',
      name: 'Dragón Articulado Crystal Flex 45cm',
      category: 'Coleccionables',
      basePrice: 21.50,
      grams: 185,
      hours: 7.2,
      dimensions: '450 x 85 x 55 mm',
      description: 'Impresión Print-in-Place de 38 eslabones móviles con filamento seda bicolor.',
      shapeType: 'dragon',
      badge: 'Print-in-Place',
    ),
    Product3D(
      id: 'nj-06',
      name: 'Dock Carga Magnética + Organizador Escritorio',
      category: 'Gaming & Setup',
      basePrice: 18.00,
      grams: 160,
      hours: 5.0,
      dimensions: '190 x 110 x 95 mm',
      description: 'Estación minimalista para teléfono, reloj inteligente, tarjetas y llaves.',
      shapeType: 'dock',
      badge: 'Nuevo',
    ),
  ];

  final List<CartItem> _cart = [];

  // Estado del Cotizador Slicer 3D
  String _customFileName = 'pieza_personalizada_nj.stl';
  double _dimX = 95;
  double _dimY = 85;
  double _dimZ = 65;
  double _infill = 25;
  int _selectedSlicerMaterialIdx = 0;
  int _selectedSlicerColorIdx = 0;
  int _slicerQty = 1;
  bool _needsCadDesign = false;

  void _addToCart(CartItem item) {
    setState(() {
      final existingIdx = _cart.indexWhere(
        (e) =>
            e.name == item.name &&
            e.materialName == item.materialName &&
            e.colorName == item.colorName,
      );
      if (existingIdx >= 0) {
        _cart[existingIdx].quantity += item.quantity;
      } else {
        _cart.add(item);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ ${item.name} agregado al pedido'),
        backgroundColor: NJColors.indigoDeep,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  double get _cartTotal =>
      _cart.fold(0.0, (sum, item) => sum + (item.unitPrice * item.quantity));

  int get _cartCount => _cart.fold(0, (sum, item) => sum + item.quantity);

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 12,
        title: Row(
          children: [
            const SizedBox(
              width: 44,
              height: 44,
              child: CustomPaint(painter: NJLogoPainter()),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) =>
                      NJColors.brandGradient.createShader(bounds),
                  child: const Text(
                    'NJ MAKER',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  '3D PRINT & DESIGN',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2.2,
                    color: isDark ? Colors.white70 : NJColors.navyDark,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Cambiar Tema',
            onPressed: widget.onToggleTheme,
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: isDark ? NJColors.cyanElectric : NJColors.navyDark,
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                onPressed: () => setState(() => _selectedIndex = 2),
                icon: Icon(
                  Icons.shopping_bag_outlined,
                  color: isDark ? Colors.white : NJColors.navyDark,
                ),
              ),
              if (_cartCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 1.5,
                    ),
                    decoration: BoxDecoration(
                      gradient: NJColors.brandGradient,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$_cartCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildCatalogTab(isDark),
          _buildSlicerQuoteTab(isDark),
          _buildCartTab(isDark),
          _buildAdminStudioTab(isDark),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (idx) => setState(() => _selectedIndex = idx),
        backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
        indicatorColor: NJColors.cyanElectric.withOpacity(0.2),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.view_in_ar_outlined),
            selectedIcon: Icon(Icons.view_in_ar, color: NJColors.cyanElectric),
            label: 'Catálogo 3D',
          ),
          const NavigationDestination(
            icon: Icon(Icons.layers_outlined),
            selectedIcon: Icon(Icons.layers, color: NJColors.purpleMaker),
            label: 'Cotizador STL',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: _cartCount > 0,
              label: Text('$_cartCount'),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            selectedIcon: const Icon(
              Icons.shopping_cart,
              color: NJColors.indigoDeep,
            ),
            label: 'Pedido',
          ),
          const NavigationDestination(
            icon: Icon(Icons.precision_manufacturing_outlined),
            selectedIcon: Icon(
              Icons.precision_manufacturing,
              color: NJColors.cyanElectric,
            ),
            label: 'Taller Admin',
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // PESTAÑA 1: CATÁLOGO 3D INTERACTIVO
  // ==========================================================================
  Widget _buildCatalogTab(bool isDark) {
    final categories = [
      'Todos',
      'Gaming & Setup',
      'Decoración',
      'Industrial & CAD',
      'Corporativo',
      'Coleccionables',
    ];

    final filtered = _selectedCategory == 'Todos'
        ? _products
        : _products.where((p) => p.category == _selectedCategory).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Banner Hero con el Logo NJ 3D en grande
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: isDark
                  ? [const Color(0xFF0F172A), const Color(0xFF1E1B4B)]
                  : [Colors.white, const Color(0xFFEEF2FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: NJColors.cyanElectric.withOpacity(0.35),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: NJColors.indigoDeep.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        gradient: NJColors.brandGradient,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'MANUFACTURA ADITIVA PRO',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Tus ideas impresas capa por capa en alta precisión',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        height: 1.2,
                        color: isDark ? Colors.white : NJColors.navyDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Personaliza el color de filamento y material en tiempo real o cotiza tu archivo STL.',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: isDark ? Colors.white70 : Colors.blueGrey[700],
                      ),
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: NJColors.indigoDeep,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => setState(() => _selectedIndex = 1),
                      icon: const Icon(Icons.upload_file, size: 18),
                      label: const Text('Cotizar Archivo 3D'),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const SizedBox(
                width: 105,
                height: 105,
                child: CustomPaint(painter: NJLogoPainter()),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // Selector de Categorías
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final cat = categories[index];
              final selected = cat == _selectedCategory;
              return ChoiceChip(
                label: Text(cat),
                selected: selected,
                onSelected: (_) => setState(() => _selectedCategory = cat),
                selectedColor: NJColors.indigoDeep,
                labelStyle: TextStyle(
                  color: selected
                      ? Colors.white
                      : (isDark ? Colors.white70 : NJColors.navyDark),
                  fontWeight: FontWeight.w600,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),

        // Tarjetas de productos con configurador interactivo
        ...filtered.map(
          (product) => ProductInteractiveCard(
            product: product,
            isDark: isDark,
            onAddToCart: _addToCart,
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // PESTAÑA 2: COTIZADOR SLICER 3D & DISEÑO CAD
  // ==========================================================================
  Widget _buildSlicerQuoteTab(bool isDark) {
    final mat = kPrintMaterials[_selectedSlicerMaterialIdx];
    final col = kFilamentColors[_selectedSlicerColorIdx];

    final volumeCm3 = (_dimX * _dimY * _dimZ) / 1000.0;
    final infillFactor = 0.18 + (_infill / 100.0) * 0.55;
    final estimatedGrams = math.max(12, (volumeCm3 * 0.42 * infillFactor).round());
    final estimatedHours = double.parse(
      math.max(0.8, (estimatedGrams / 28.0)).toStringAsFixed(1),
    );
    final cadFee = _needsCadDesign ? 15.0 : 0.0;
    final baseUnitCost =
        4.50 + (estimatedGrams * mat.pricePerGram) + (estimatedHours * 1.45) + cadFee;
    final discount = _slicerQty >= 10
        ? 0.85
        : (_slicerQty >= 5 ? 0.92 : 1.0);
    final finalUnitPrice = double.parse((baseUnitCost * discount).toStringAsFixed(2));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            border: Border.all(color: NJColors.cyanElectric.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: NJColors.brandGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.layers, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cotizador Slicer 3D en Vivo',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : NJColors.navyDark,
                          ),
                        ),
                        const Text(
                          'Calcula gramos, tiempo de máquina y precio al instante',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Previsualización de Cama Caliente 3D con la pieza
              Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F172A), Color(0xFF1E1B4B)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(double.infinity, 160),
                      painter: SlicerBedPreviewPainter(
                        primaryColor: col.primaryColor,
                        secondaryColor: col.secondaryColor,
                        scaleX: _dimX / 220,
                        scaleZ: _dimZ / 220,
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 12,
                      child: Text(
                        'ARCHIVO: $_customFileName',
                        style: const TextStyle(
                          color: NJColors.cyanElectric,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${_dimX.round()}x${_dimY.round()}x${_dimZ.round()} mm | $estimatedGrams g | ${estimatedHours}h',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Nombre del archivo o proyecto
              TextField(
                decoration: InputDecoration(
                  labelText: 'Nombre de tu pieza o archivo (.STL / .3MF / Idea)',
                  prefixIcon: const Icon(Icons.description_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (v) => setState(
                  () => _customFileName = v.isEmpty ? 'pieza_nj.stl' : v,
                ),
              ),
              const SizedBox(height: 16),

              // Sliders de dimensiones X, Y, Z
              Text(
                'Dimensiones en Milímetros (X: ${_dimX.round()} mm | Y: ${_dimY.round()} mm | Z: ${_dimZ.round()} mm)',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              Slider(
                value: _dimX,
                min: 20,
                max: 250,
                activeColor: NJColors.cyanElectric,
                label: 'Ancho X: ${_dimX.round()} mm',
                onChanged: (v) => setState(() => _dimX = v),
              ),
              Slider(
                value: _dimY,
                min: 20,
                max: 250,
                activeColor: NJColors.indigoDeep,
                label: 'Fondo Y: ${_dimY.round()} mm',
                onChanged: (v) => setState(() => _dimY = v),
              ),
              Slider(
                value: _dimZ,
                min: 15,
                max: 250,
                activeColor: NJColors.purpleMaker,
                label: 'Alto Z: ${_dimZ.round()} mm',
                onChanged: (v) => setState(() => _dimZ = v),
              ),

              const SizedBox(height: 6),
              Text(
                'Densidad de Relleno Interno (Infill: ${_infill.round()}%)',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              Slider(
                value: _infill,
                min: 15,
                max: 100,
                divisions: 17,
                activeColor: NJColors.purpleMaker,
                onChanged: (v) => setState(() => _infill = v),
              ),

              const SizedBox(height: 8),
              const Text(
                'Material de Impresión:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(kPrintMaterials.length, (i) {
                  final m = kPrintMaterials[i];
                  final sel = i == _selectedSlicerMaterialIdx;
                  return ChoiceChip(
                    label: Text(m.name),
                    selected: sel,
                    selectedColor: NJColors.indigoDeep,
                    labelStyle: TextStyle(
                      color: sel
                          ? Colors.white
                          : (isDark ? Colors.white : NJColors.navyDark),
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (_) =>
                        setState(() => _selectedSlicerMaterialIdx = i),
                  );
                }),
              ),

              const SizedBox(height: 14),
              const Text(
                'Color de Filamento NJ Maker:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                runSpacing: 8,
                children: List.generate(kFilamentColors.length, (i) {
                  final c = kFilamentColors[i];
                  final sel = i == _selectedSlicerColorIdx;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedSlicerColorIdx = i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: sel ? NJColors.cyanElectric : Colors.grey.shade400,
                          width: sel ? 2.2 : 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [c.primaryColor, c.secondaryColor],
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(c.name, style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 12),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Requiero modelado 3D desde cero (Diseño CAD)',
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
                ),
                subtitle: const Text(
                  'Incluye diseño paramétrico a partir de plano o foto (+\$15.00)',
                  style: TextStyle(fontSize: 11.5),
                ),
                value: _needsCadDesign,
                activeColor: NJColors.cyanElectric,
                onChanged: (v) => setState(() => _needsCadDesign = v),
              ),

              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'PRECIO ESTIMADO',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                      Text(
                        '\$${(finalUnitPrice * _slicerQty).toStringAsFixed(2)} USD',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: NJColors.cyanElectric,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (_slicerQty > 1) setState(() => _slicerQty--);
                        },
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Text(
                        '$_slicerQty uds',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () => setState(() => _slicerQty++),
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: NJColors.indigoDeep,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    _addToCart(
                      CartItem(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        name: 'Impresión 3D: $_customFileName',
                        materialName: mat.name,
                        colorName: col.name,
                        previewColor: col.primaryColor,
                        unitPrice: finalUnitPrice,
                        specs:
                            '${_dimX.round()}x${_dimY.round()}x${_dimZ.round()}mm | Infill ${_infill.round()}% | $estimatedGrams g',
                        quantity: _slicerQty,
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text(
                    'AGREGAR COTIZACIÓN AL PEDIDO',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // PESTAÑA 3: CARRITO Y GENERADOR DE ORDEN WHATSAPP
  // ==========================================================================
  Widget _buildCartTab(bool isDark) {
    if (_cart.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 90,
                height: 90,
                child: CustomPaint(painter: NJLogoPainter()),
              ),
              const SizedBox(height: 18),
              const Text(
                'Tu orden de impresión 3D está vacía',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Agrega piezas del catálogo o cotiza un archivo STL a medida.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => setState(() => _selectedIndex = 0),
                child: const Text('Explorar Catálogo 3D'),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ..._cart.asMap().entries.map((entry) {
          final idx = entry.key;
          final item = entry.value;
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: CircleAvatar(
                backgroundColor: item.previewColor,
                child: const Icon(Icons.view_in_ar, color: Colors.white),
              ),
              title: Text(
                item.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${item.materialName} • ${item.colorName}
${item.specs}
\$${item.unitPrice.toStringAsFixed(2)} c/u',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      setState(() {
                        if (item.quantity > 1) {
                          item.quantity--;
                        } else {
                          _cart.removeAt(idx);
                        }
                      });
                    },
                  ),
                  Text(
                    '${item.quantity}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () => setState(() => item.quantity++),
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: NJColors.brandGradient,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'TOTAL DE LA ORDEN:',
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '\$${_cartTotal.toStringAsFixed(2)} USD',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: NJColors.navyDark,
                  ),
                  onPressed: () {
                    final buffer = StringBuffer();
                    buffer.writeln('🚀 *NUEVO PEDIDO - NJ MAKER 3D PRINT & DESIGN*');
                    buffer.writeln('-----------------------------------------');
                    for (final c in _cart) {
                      buffer.writeln(
                        '• ${c.quantity}x ${c.name} (${c.materialName} - ${c.colorName}) = \$${(c.unitPrice * c.quantity).toStringAsFixed(2)}',
                      );
                    }
                    buffer.writeln('-----------------------------------------');
                    buffer.writeln(
                      '💰 *TOTAL: \$${_cartTotal.toStringAsFixed(2)} USD*',
                    );

                    Clipboard.setData(ClipboardData(text: buffer.toString()));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          '📋 Resumen del pedido copiado al portapapeles listo para enviar por WhatsApp',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  icon: const Icon(Icons.copy_all_rounded),
                  label: const Text(
                    'COPIAR ORDEN PARA WHATSAPP',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // PESTAÑA 4: PANEL ADMINISTRADOR TALLER (CREAR NUEVOS PRODUCTOS)
  // ==========================================================================
  Widget _buildAdminStudioTab(bool isDark) {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController(text: '20.00');
    final gramsCtrl = TextEditingController(text: '150');
    final descCtrl = TextEditingController();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Publicar Nuevo Producto en NJ MAKER',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nombre del Producto 3D',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: priceCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Precio Base (USD)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: gramsCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Peso (Gramos)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descCtrl,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Descripción técnica de la pieza',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: NJColors.purpleMaker,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (nameCtrl.text.trim().isEmpty) return;
                    setState(() {
                      _products.insert(
                        0,
                        Product3D(
                          id: 'nj-${DateTime.now().millisecondsSinceEpoch}',
                          name: nameCtrl.text.trim(),
                          category: 'Gaming & Setup',
                          basePrice: double.tryParse(priceCtrl.text) ?? 20.0,
                          grams: int.tryParse(gramsCtrl.text) ?? 150,
                          hours: 4.0,
                          dimensions: '120 x 120 x 140 mm',
                          description: descCtrl.text.trim().isEmpty
                              ? 'Pieza impresa en 3D con calidad de estudio NJ MAKER.'
                              : descCtrl.text.trim(),
                          shapeType: 'stand',
                          badge: 'Nuevo',
                        ),
                      );
                      _selectedIndex = 0;
                    });
                  },
                  icon: const Icon(Icons.add_box_rounded),
                  label: const Text('AGREGAR AL CATÁLOGO'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// TARJETA DE PRODUCTO CON PERSONALIZACIÓN EN VIVO
// ============================================================================
class ProductInteractiveCard extends StatefulWidget {
  final Product3D product;
  final bool isDark;
  final ValueChanged<CartItem> onAddToCart;

  const ProductInteractiveCard({
    super.key,
    required this.product,
    required this.isDark,
    required this.onAddToCart,
  });

  @override
  State<ProductInteractiveCard> createState() => _ProductInteractiveCardState();
}

class _ProductInteractiveCardState extends State<ProductInteractiveCard> {
  int _selectedColorIdx = 0;
  int _selectedMatIdx = 0;

  @override
  Widget build(BuildContext context) {
    final color = kFilamentColors[_selectedColorIdx];
    final mat = kPrintMaterials[_selectedMatIdx];
    final finalPrice = double.parse(
      (widget.product.basePrice * mat.multiplier).toStringAsFixed(2),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.primaryColor.withOpacity(0.35),
          width: 1.4,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vista 3D Simulada que cambia de color al instante
              Container(
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [color.primaryColor, color.secondaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.view_in_ar, color: Colors.white, size: 38),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.product.grams}g • ${widget.product.hours}h',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: NJColors.cyanElectric.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.product.badge,
                        style: const TextStyle(
                          color: NJColors.cyanElectric,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.product.name,
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.product.description,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Selector rápido de color de filamento
          Row(
            children: [
              const Text(
                'Filamento:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 26,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: kFilamentColors.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, idx) {
                      final c = kFilamentColors[idx];
                      final isSel = idx == _selectedColorIdx;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedColorIdx = idx),
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [c.primaryColor, c.secondaryColor],
                            ),
                            border: Border.all(
                              color: isSel ? Colors.white : Colors.transparent,
                              width: 2.5,
                            ),
                            boxShadow: isSel
                                ? [
                                    BoxShadow(
                                      color: c.primaryColor.withOpacity(0.6),
                                      blurRadius: 6,
                                    )
                                  ]
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Selector rápido de material
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Wrap(
                spacing: 6,
                children: List.generate(kPrintMaterials.length, (mIdx) {
                  final m = kPrintMaterials[mIdx];
                  final isSel = mIdx == _selectedMatIdx;
                  return ChoiceChip(
                    visualDensity: VisualDensity.compact,
                    label: Text(
                      m.name.split(' ').first,
                      style: const TextStyle(fontSize: 11),
                    ),
                    selected: isSel,
                    onSelected: (_) => setState(() => _selectedMatIdx = mIdx),
                  );
                }),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: NJColors.indigoDeep,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  widget.onAddToCart(
                    CartItem(
                      id: '${widget.product.id}-${mat.id}-${color.id}',
                      name: widget.product.name,
                      materialName: mat.name,
                      colorName: color.name,
                      previewColor: color.primaryColor,
                      unitPrice: finalPrice,
                      specs: widget.product.dimensions,
                    ),
                  );
                },
                icon: const Icon(Icons.add_shopping_cart, size: 16),
                label: Text('\$${finalPrice.toStringAsFixed(2)}'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// CUSTOM PAINTER: LOGOTIPO VECTORIAL OFICIAL "NJ MAKER" CON EXTRUSOR 3D
// ============================================================================
class NJLogoPainter extends CustomPainter {
  const NJLogoPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Eje horizontal superior del extrusor
    final railPaint = Paint()
      ..color = const Color(0xFF334155)
      ..strokeWidth = h * 0.045
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(w * 0.16, h * 0.16),
      Offset(w * 0.84, h * 0.16),
      railPaint,
    );

    // 2. Trazo tubular 3D "NJ" en degradado Cian -> Azul -> Púrpura
    final gradientPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFF00B4D8),
          Color(0xFF3B82F6),
          Color(0xFF7C3AED),
          Color(0xFF9333EA),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.15
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(w * 0.22, h * 0.84)
      ..lineTo(w * 0.22, h * 0.42)
      ..cubicTo(w * 0.22, h * 0.28, w * 0.36, h * 0.28, w * 0.43, h * 0.46)
      ..lineTo(w * 0.54, h * 0.74)
      ..cubicTo(w * 0.62, h * 0.90, w * 0.78, h * 0.86, w * 0.78, h * 0.66)
      ..lineTo(w * 0.78, h * 0.36);

    canvas.drawPath(path, gradientPaint);

    // Columna central bajo la boquilla
    final centerPillar = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF00B4D8), Color(0xFF4F46E5)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(w * 0.45, h * 0.32, w * 0.16, h * 0.40))
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.13
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(w * 0.54, h * 0.36),
      Offset(w * 0.54, h * 0.66),
      centerPillar,
    );

    // 3. Cabezal Extrusor 3D en la parte superior central
    final headRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(w * 0.54, h * 0.16),
        width: w * 0.16,
        height: h * 0.16,
      ),
      const Radius.circular(4),
    );
    canvas.drawRRect(headRect, Paint()..color = const Color(0xFF1E293B));

    // Boquilla (Nozzle) depositando filamento cian brillante
    final nozzlePath = Path()
      ..moveTo(w * 0.49, h * 0.24)
      ..lineTo(w * 0.59, h * 0.24)
      ..lineTo(w * 0.54, h * 0.32)
      ..close();
    canvas.drawPath(nozzlePath, Paint()..color = const Color(0xFF00B4D8));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ============================================================================
// CUSTOM PAINTER: VISTA DE CAPAS DEL COTIZADOR SLICER 3D
// ============================================================================
class SlicerBedPreviewPainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;
  final double scaleX;
  final double scaleZ;

  SlicerBedPreviewPainter({
    required this.primaryColor,
    required this.secondaryColor,
    required this.scaleX,
    required this.scaleZ,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.cyanAccent.withOpacity(0.15)
      ..strokeWidth = 1;

    for (double x = 20; x < size.width; x += 24) {
      canvas.drawLine(
        Offset(x, size.height * 0.72),
        Offset(x - 15, size.height * 0.92),
        gridPaint,
      );
    }

    final boxW = (size.width * 0.45 * scaleX).clamp(45.0, 150.0);
    final boxH = (size.height * 0.55 * scaleZ).clamp(32.0, 95.0);
    final centerX = size.width / 2;
    final bottomY = size.height * 0.78;

    final layers = 10;
    for (int i = 0; i < layers; i++) {
      final t = i / layers;
      final layerColor = Color.lerp(primaryColor, secondaryColor, t)!;
      final y = bottomY - (i * (boxH / layers));
      final rect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(centerX, y),
          width: boxW * (1 - t * 0.15),
          height: (boxH / layers) * 0.78,
        ),
        const Radius.circular(4),
      );
      canvas.drawRRect(rect, Paint()..color = layerColor);
    }
  }

  @override
  bool shouldRepaint(covariant SlicerBedPreviewPainter oldDelegate) =>
      oldDelegate.primaryColor != primaryColor ||
      oldDelegate.secondaryColor != secondaryColor ||
      oldDelegate.scaleX != scaleX ||
      oldDelegate.scaleZ != scaleZ;
}

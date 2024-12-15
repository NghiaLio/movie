import 'package:flutter/material.dart';
import '../../Domain/Entities/OptionSuggest.dart';

class Searchsuggest extends StatefulWidget {
  final TextEditingController Searchcontroller;
  final TextEditingController Countrycontroller;
  final List<DropdownMenuEntry<dynamic>> list_Country;
  Function(dynamic ob)? selectCountry;
  Function(String label, String slug) setSuggestMovieSearch;

  Searchsuggest(
      {super.key,
      required this.list_Country,
      required this.selectCountry,
      required this.setSuggestMovieSearch,
      required this.Searchcontroller,
      required this.Countrycontroller});

  @override
  State<Searchsuggest> createState() => _SearchsuggestState();
}

class _SearchsuggestState extends State<Searchsuggest> {
  //list suggest
  List<suggestion> suggestSearch = [
    suggestion(label: 'Phim bộ', slug: 'phim-bo'),
    suggestion(label: 'Phim lẻ', slug: 'phim-le'),
    suggestion(label: 'Phim vietsub', slug: 'phim-vietsub'),
    suggestion(label: 'Phim thuyết minh', slug: 'phim-thuyet-minh'),
    suggestion(label: 'Phim lồng tiếng', slug: 'phim-long-tieng'),
  ];
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return
        //Option suggest
        Column(
      children: [
        //item
        Container(
          height:
              size.width > 600 ? size.height * 0.2 : size.height * 0.15 + 10,
          width: size.width,
          padding: const EdgeInsets.only(top: 10.0),
          child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: suggestSearch.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 17 / 3,
                  crossAxisCount: size.width > 600 ? 4 : 2),
              itemBuilder: (context, index) => suggestItem(
                  suggestSearch[index].label, suggestSearch[index].slug)),
        ),

        //country
        Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary.withOpacity(0.2),
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          child: DropdownMenu(
              width: size.width > 600 ? size.width - 30 : size.width * 0.8 + 50,
              inputDecorationTheme:
                  const InputDecorationTheme(enabledBorder: InputBorder.none),
              leadingIcon: const Icon(
                Icons.public,
                size: 26,
              ),
              label: const Text(
                'Chọn quốc gia',
                style: TextStyle(fontSize: 20),
              ),
              onSelected: widget.selectCountry,
              textStyle: const TextStyle(fontSize: 20),
              menuStyle: MenuStyle(
                backgroundColor: WidgetStatePropertyAll<Color>(
                  Theme.of(context).colorScheme.tertiary.withOpacity(0.2),
                ),
              ),
              enableFilter: true,
              menuHeight: size.height * 0.3,
              controller: widget.Countrycontroller,
              requestFocusOnTap: true,
              dropdownMenuEntries: widget.list_Country),
        ),
      ],
    );
  }

  Widget suggestItem(String label, String slug) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => widget.setSuggestMovieSearch(label, slug),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: Theme.of(context).colorScheme.tertiary.withOpacity(0.2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: size.width > 600 ? 18 : 16),
            ),
            const Icon(
              Icons.keyboard_double_arrow_up_rounded,
              size: 20,
            )
          ],
        ),
      ),
    );
  }
}

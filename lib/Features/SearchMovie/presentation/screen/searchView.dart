import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../../../Infor_of_Movie/Presentation/screen/movieInfoScreen.dart';
import '../../Domain/Entities/searchMovie.dart';
import '../Cubit/searchCubit.dart';
import '../Cubit/searchState.dart';
import 'searchLayout.dart';
import 'searchSuggest.dart';

class Searchview extends StatefulWidget {
  const Searchview({super.key});

  @override
  State<Searchview> createState() => _SearchviewState();
}

class _SearchviewState extends State<Searchview> {
  TextEditingController Countrycontroller = TextEditingController();
  TextEditingController Searchcontroller = TextEditingController();

  bool isSearch = false;

  //back to previous page
  void backToPage() {
    Navigator.pop(context);
    context.read<Searchcubit>().getCountry();
  }

  //option suggest select
  void setSuggestMovieSearch(String label, String slug) {
    //set search
    setState(() {
      Searchcontroller.text = 'Từ khóa: $label';
    });
    //hide keyboard
    FocusScope.of(context).requestFocus(FocusNode());

    //get movie
    context.read<Searchcubit>().getMoviebySuggest(slug);
  }

  //select country
  void selectCountry(dynamic country) {
    if (country != null) {
      setState(() {
        Searchcontroller.text = 'quoc_gia:$country';
        isSearch = !isSearch;
      });
    }
    //hide keyboard
    FocusScope.of(context).requestFocus(FocusNode());

    //get movie
    context.read<Searchcubit>().getmovieCountry(country.toString());
  }

  //change value search
  void onChanged(String keyword) {
    if(keyword.isEmpty){
      //if don't enter keyword return search Suggest
      context.read<Searchcubit>().getCountry();
    }else{
      // enter keyword return movie of keyword
      context.read<Searchcubit>().getMoviebykeyword(keyword);
    }

  }

  //tap to seen infor of movie
  void toToMovieInfo(String slug, String id) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (c) => Movieinfoscreen(
                  slugMovie: slug,
                  idMovie: id,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: backToPage, icon: const Icon(Icons.arrow_back_ios)),
          title: const Text('Tìm kiếm phim'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                //search barr
                TextField(
                  autofocus: true,
                  // onTap: () => Searchcontroller.clear(),
                  controller: Searchcontroller,
                  onChanged: (value) {
                    onChanged(value);
                  },
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 10),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Icon(
                        Icons.search,
                        size: 28,
                      ),
                    ),
                    hintText: 'Nhập từ khóa..',
                    filled: true,
                    fillColor:
                        Theme.of(context).colorScheme.tertiary.withOpacity(0.2),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                  ),
                ),

                // view
                BlocBuilder<Searchcubit, Searchstate>(
                    builder: (context, states) {
                  print(states);
                  if (states is loadedCountry) {
                    final listSuggest = states.list_country!.list_Country;
                    List<DropdownMenuEntry<dynamic>> dropdownMenuEntries =
                        listSuggest
                            .map((e) => DropdownMenuEntry(
                                value: e.slug,
                                label: e.name,
                                style: MenuItemButton.styleFrom(
                                    textStyle: const TextStyle(fontSize: 20))))
                            .toList();

                    return Searchsuggest(
                      Searchcontroller: Searchcontroller,
                      Countrycontroller: Countrycontroller,
                      selectCountry: selectCountry,
                      setSuggestMovieSearch: setSuggestMovieSearch,
                      list_Country: dropdownMenuEntries,
                    );
                  } else if (states is loadedMovieofCountry) {
                    List<Searchmovie> listMovieofCountry =
                        states.listMovieCountry!.listSearch;
                    print(listMovieofCountry.length);

                    return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8 - 5,
                        child: Searchlayout(
                          listMoviebySearch: listMovieofCountry,
                          tapToMovieInfo: toToMovieInfo,
                        ));
                  } else if (states is loadedMovieofSuggest) {
                    List<Searchmovie> listSearch =
                        states.listMovieSuggest!.listSearch;
                    print(listSearch.length);
                    return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8 - 5,
                        child: Searchlayout(
                          listMoviebySearch: listSearch,
                          tapToMovieInfo: toToMovieInfo,
                        ));
                  } else if (states is loadedSearchbykeyword) {
                    List<Searchmovie?> listSearch =
                        context.read<Searchcubit>().listSearch;
                    return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8 - 5,
                        child: Searchlayout(
                          listMoviebySearch: listSearch,
                          tapToMovieInfo: toToMovieInfo,
                        ));
                  } else {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: const Center(
                        child: LoadingIndicator(indicatorType: Indicator.pacman),
                      ),
                    );
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

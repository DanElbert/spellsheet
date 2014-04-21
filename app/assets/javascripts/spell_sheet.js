

$(document).ready(function() {

  $("#spellsheet").on("mouseenter", ".memorization_spell", function() {
    $(this).find(".spell_controls").show();
  });

  $("#spellsheet").on("mouseleave", ".memorization_spell", function() {
    $(this).find(".spell_controls").hide();
  });
});


// ========================================
// SpellSheetModel
// ========================================
function SpellSheetModel(data) {
  this.sections = ko.observableArray();
  this.libraryIdValue = data.library_id;

  this.mode = ko.observable("memorizing");

  this.modeText = ko.computed(function() {
    if (this.mode() == "memorizing") {
      return "Memorizing";
    } else {
      return "Casting";
    }
  }, this);

  this.spells = [];

  _.each(data.spells, function(s) {
    this.spells.push(new SpellModel(s, this));
  }, this);

  this.rebuild();

  this.summaryMarkup = ko.computed(function() {
    var markup = "";
    _.each(this.availableLevels(), function(lvl) {
      markup += "<div class=\"level_summary\">\n";
      markup += "<span class=\"level\">" + lvl + "</span>";
      markup += "<span class=\"memorization_count\">" + this.memorizedCountForLevel(lvl) + "</span>";
      markup += "</div>"
    }, this);
    return markup;
  }, this);

  this.sectionSortFunction = function(left, right) {
    if (left.section() == right.section()) {
      return 0;
    }

    return left.section() < right.section() ? -1 : 1;
  };
}

SpellSheetModel.prototype.toggleMode = function() {
  if (this.mode() == "memorizing") {
    this.mode("casting");
  } else {
    this.mode("memorizing");
  }
  this.rebuild();
};

SpellSheetModel.prototype.rebuild = function() {
  this.sections([]);

  for (var x = 0; x < this.spells.length; x++) {
    this.addSpellToSection(this.spells[x]);
  }

  this.sort();
};

SpellSheetModel.prototype.availableLevels = function() {
  var levels = [];

  _.each(this.sections(), function(section) {
    _.each(section.levels(), function(level) {
      levels.push(level.level());
    })
  });

  return _.uniq(levels);
};

SpellSheetModel.prototype.memorizedCountForLevel = function(level) {
  var count = 0;

  _.each(this.spells, function(spell) {
    if (spell.level == level) {
      count += spell.numberMemorized();
    }
  });

  return count;
};

SpellSheetModel.prototype.libraryId = function() {
  return this.libraryIdValue;
};

SpellSheetModel.prototype.addSpellToSection = function(spell) {
  var section = null;
  for (var x = 0; x < this.sections().length; x++) {
    if (this.sections()[x].section() == spell.section()) {
      section = this.sections()[x];
      break;
    }
  }

  if (section == null) {
    section = new SectionModel(spell.section(), this);
    this.sections.push(section);
  }

  section.addSpell(spell);
};

SpellSheetModel.prototype.addSpell = function(spellData) {
  var spell = new SpellModel(spellData, this);
  this.spells.push(spell);
  this.addSpellToSection(spell);
};

SpellSheetModel.prototype.removeSpell = function(key) {
  var index = -1;

  for (var x = 0; x < this.spells.length; x++) {
    if (this.spells[x].key == key) {
      index = x;
      break;
    }
  }

  if (index >= 0) {
    this.spells.splice(index, 1);
    this.rebuild();
  }
};

SpellSheetModel.prototype.updateSpell = function(spell_data) {
  var spell = _.find(this.spells, function(s) {
    return s.key == spell_data.key;
  });

  if (spell) {
    spell.update(spell_data);
  }
};

SpellSheetModel.prototype.sort = function() {
  this.sections.sort(this.sectionSortFunction);
  _.each(this.sections(), function(s) {
    s.sort();
  });
};


// ========================================
// SectionModel
// ========================================
function SectionModel(section, container) {
  this.container = container;
  this.section = ko.observable(section);
  this.levels = ko.observableArray();

  this.levelSortFunction = function(left, right) {
    if (left.level() == right.level()) {
      return 0;
    }

    return left.level() < right.level() ? -1 : 1;
  };
}

SectionModel.prototype.addSpell = function(spell) {
  var level = null;
  for (var x = 0; x < this.levels().length; x++) {
    if (this.levels()[x].level() == spell.level) {
      level = this.levels()[x];
      break;
    }
  }

  if (level == null) {
    level = new LevelModel(spell.level, this);
    this.levels.push(level);
  }

  level.addSpell(spell);
};

SectionModel.prototype.sort = function() {
  this.levels.sort(this.levelSortFunction);
  _.each(this.levels(), function(l) {
    l.sort();
  });
};


// ========================================
// LevelModel
// ========================================
function LevelModel(level, container) {
  this.container = container;
  this.level = ko.observable(level);
  this.spells = ko.observableArray();

  this.spellSortFunction = function(left, right) {
    if (left.key == right.key) {
      return 0;
    }

    return left.name() < right.name() ? -1 : 1;
  };
}

LevelModel.prototype.addSpell = function(spell) {
  this.spells.push(spell);
};

LevelModel.prototype.sort = function() {
  this.spells.sort(this.spellSortFunction);
};


// ========================================
// SpellModel
// ========================================
function SpellModel(spell, spellSheet) {
  this.spellSheet = spellSheet;
  this.key = spell.key;
  //this.section = spell.section;
  this.level = spell.level;
  this.spellId = spell.spell_id;
  this.memorizedId = spell.memorized_spell_id;

  this.isLearned = ko.observable();
  this.numberMemorized = ko.observable();
  this.name = ko.observable();
  this.components = ko.observable();
  this.school = ko.observable();
  this.description = ko.observable();

  this.update(spell);

  this.libraryId = ko.computed(function() {
    return this.spellSheet.libraryId();
  }, this);

  this.mode = ko.computed(function() {
    return this.spellSheet.mode();
  }, this);

  this.section = ko.computed(function() {
    if (this.mode() == 'memorizing') {
      return 0;
    } else {
      return (this.numberMemorized() > 0) ? 0 : 1;
    }
  }, this);

  this.detailsUrl = ko.computed(function() {
    if (this.spellId) {
      return getContextRoot() + "/spells/" + this.spellId;
    } else {
      return "#";
    }
  }, this);

  this.quickMemorizeUrl = ko.computed(function() {

    var data = {
      spell_id: this.spellId,
      memorized_spell_id: this.memorizedId
    };

    return getContextRoot() + "/libraries/" + this.libraryId() + "/memorize_spell.js?" + $.param(data);
  }, this);

  this.memorizeUrl = ko.computed(function() {

    var data = {
      spell_id: this.spellId
    };

    return getContextRoot() + "/libraries/" + this.libraryId() + "/custom_spell.js?" + $.param(data);
  }, this);

  this.castUrl = ko.computed(function() {

    var data = {
      memorized_spell_id: this.memorizedId
    };

    return getContextRoot() + "/libraries/" + this.libraryId() + "/cast_spell.js?" + $.param(data);
  }, this);
}

SpellModel.prototype.update = function(spell) {
  this.isLearned(spell.is_learned);
  this.numberMemorized(spell.number_memorized);
  this.name(spell.name);
  this.components(spell.short_components);
  this.school(spell.formatted_school);
  this.description(spell.short_description);
};

SpellModel.prototype.remove = function() {
  this.container.spells.remove(this);
};